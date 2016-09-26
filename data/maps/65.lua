local map = ...
local game = map:get_game()
-- Dungeon 5 B1

local init_guards = require("maps/prison_guard")
init_guards(map)

local prison_2_nb_messages = 0
local door_sets = { -- possible doors open when going to prison
  { door_b, door_d, door_f, door_h, door_g },
  { door_b, door_d, door_f, door_h, door_g },
  { door_b, door_d, door_e, door_f, door_g },
  { door_b, door_d, door_e, door_f, door_g },
  { door_a, door_c, door_e, door_d, door_f, door_h },
}

local function init_guard(guard, x, y, direction, path)

  guard:set_position(x, y)
  local sprite = guard:get_sprite()
  if path ~= nil then
    local m = sol.movement.create("path")
    m:set_path(path)
    m:set_speed(72)
    m:set_loop(true)
    m:set_ignore_obstacles(true)
    m:start(guard)
  else
    guard:stop_movement()
    sprite:set_animation("stopped")
    sprite:set_direction(direction)
  end
end

local function init_guards()

  init_guard(guard_1, 296, 573, 2)
  init_guard(guard_2, 296, 685, 2)
  init_guard(guard_3, 288, 821, 2,
      {4,4,4,4,4,4,4,4,4,
      6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
      4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4})
  init_guard(guard_4, 776, 917, 2)
  init_guard(guard_5, 920, 725, 2,
      {4,4,4,4,4,4,4,4,
      2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
      4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4})
  init_guard(guard_6, 1080, 597, 2,
      {2,2,2,2,2,2,2,2,
      4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
      6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2})
end

function map:on_started(destination)

  if destination == from_outside_hole then
    hero:set_direction(2)
  end

  if not game:get_value("b907") then
    -- this door is open until the main entrance door of
    -- the castle is open
    map:set_doors_open("n_door", true)
  end

  if game:get_value("b511") then
    prison_1_lock:remove()
  end

  if game:get_value("b512") then
    prison_2_nb_messages = 3
  end

  if not game:get_value("b519") then
    boss_key_chest:set_enabled(false)
  end

  -- bomb bag 2 or 3
  local variant = 2
  if game:get_value("b938") then
    -- already has the other one
    variant = 3
  end
  map:create_destructible{
    x = 320,
    y = 245,
    layer = 1,
    treasure_name = "bomb_bag",
    treasure_variant = variant,
    treasure_savegame_variable = "b510",
    sprite = "entities/pot",
    destruction_sound = "stone",
    damage_on_enemies = 2,
  }

  -- initialize doors
  local i = 1
  if destination == prison then
    i = math.random(#door_sets)
  end
  for _, door in ipairs(door_sets[i]) do
    map:set_doors_open(door:get_name(), true)
  end

  init_guards()
end

function map:init_prison()

  prison_2_lock:set_position(648, 325)
end

function map:on_opening_transition_finished(destination)

  -- show the welcome message
  if destination == from_outside_hole then
    game:start_dialog("dungeon_5.welcome")
  end
end

function prison_sensor:on_activated()

  init_guards()

  -- change the configuration of the doors
  local i = math.random(#door_sets)
  map:set_doors_open("door", false)
  for _, door in ipairs(door_sets[i]) do
    map:set_doors_open(door:get_name(), true)
  end
end

function prison_1_lock:on_interaction()

  if not game:has_item("iron_key") then
    game:start_dialog("dungeon_5.prison_1_locked")
  else
    game:start_dialog("dungeon_5.prison_1_use_iron_key", function()
      sol.audio.play_sound("secret")
      sol.audio.play_sound("door_open")
      prison_1_lock:remove()
      game:set_value("b511", true)
    end)
  end
end

function prison_2_lock:on_interaction()

  prison_2_nb_messages = prison_2_nb_messages + 1
  if prison_2_nb_messages <= 3 then
    game:start_dialog("dungeon_5.prison_2_locked_" .. prison_2_nb_messages)
  else
    sol.audio.play_sound("secret")
    sol.audio.play_sound("door_open")
    prison_2_lock:set_position(648, -32)
    game:set_value("b512", true)
  end
end

function weak_wall_a:on_opened()

  sol.audio.play_sound("secret")
end

function weak_wall_b:on_opened()

  sol.audio.play_sound("secret")
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "boss_key" then
    -- the hero was unfrozen by the chest, so cancel a possible previous guard
    -- (putting chests in the area of guards is probably not a good idea)
    map:cancel_prison()
  end
end

