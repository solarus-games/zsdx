local map = ...
local game = map:get_game()
-- Dungeon 3 4F

local fighting_miniboss = false
local fighting_boss = false

function map:on_started(destination)

  if miniboss ~= nil then
    miniboss:set_enabled(false)
  end
  if boss ~= nil then
    boss:set_enabled(false)
  end

  map:set_doors_open("miniboss_door", true)
  map:set_doors_open("boss_door", true)
  if destination == from_5f_c
      or game:get_value("b903") then
    map:set_doors_open("final_room_door", true)
  end
end

function start_miniboss_sensor:on_activated()

  if not game:get_value("b901")
      and not fighting_miniboss then
    -- the miniboss is alive
    map:close_doors("miniboss_door")
    hero:walk(666666, false, false)
  end
end

function start_miniboss_sensor_2:on_activated()

  if not game:get_value("b901")
      and not fighting_miniboss then
    hero:freeze()
    sol.audio.stop_music()
    sol.timer.start(1000, function()
      sol.audio.play_music("boss")
      miniboss:set_enabled(true)
      map:set_entities_enabled("miniboss_prickles", true)
      hero:unfreeze()
    end)
    fighting_miniboss = true
  end
end

function start_boss_sensor:on_activated()

  if not game:get_value("b902")
      and not fighting_boss then
    hero:freeze()
    map:close_doors("boss_door")
    sol.audio.stop_music()
    sol.timer.start(1000, function()
      boss:set_enabled(true)
      game:start_dialog("dungeon_3.arbror_hello", function()
        hero:unfreeze()
        sol.audio.play_music("boss")
        fighting_boss = true
      end)
    end)
  end
end

if miniboss ~= nil then
  function miniboss:on_dead()

    sol.audio.play_music("dark_world_dungeon")
    map:open_doors("miniboss_door")
    map:set_entities_enabled("miniboss_prickles", false)
  end
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "heart_container" then
    sol.audio.play_music("victory")
    hero:freeze()
    hero:set_direction(3)
    sol.timer.start(9000, function()
      map:open_doors("final_room_door")
      sol.audio.play_sound("secret")
      hero:unfreeze()
    end)
  end
end

