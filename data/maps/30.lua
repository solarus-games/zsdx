local map = ...
local game = map:get_game()
-- Dungeon 2 1F

local fighting_miniboss = false
local camera_back_start_timer = false

local function open_hidden_stairs()
  map:set_entities_enabled("hidden_stairs_closed", false)
  map:set_entities_enabled("hidden_stairs_open", true)
end

local function open_hidden_door()
  map:set_entities_enabled("hidden_door_closed", false)
  map:set_entities_enabled("hidden_door_open", true)
end

local function check_eye_statues()

  if left_eye_switch:is_activated() and right_eye_switch:is_activated() then

    left_eye_switch:set_activated(false)
    right_eye_switch:set_activated(false)

    if not game:get_value("b90") then
      map:move_camera(456, 232, 250, function()
        sol.audio.play_sound("secret")
        open_hidden_stairs()
        game:set_value("b90", true)
      end)
    elseif not game:get_value("b91") then
      map:move_camera(520, 320, 250, function()
        sol.audio.play_sound("secret")
        open_hidden_door()
        game:set_value("b91", true)
      end)
    end
  end
end

function map:on_started(destination)

  -- west barrier
  if game:get_value("b78") then
    barrier:set_enabled(false)
    barrier_switch:set_activated(true)
  end

  -- hidden stairs
  if game:get_value("b90") then
    open_hidden_stairs()
  end

  -- hidden door
  if game:get_value("b91") then
    open_hidden_door()
  end

  -- miniboss
  map:set_doors_open("stairs_door", true)
  map:set_doors_open("miniboss_door", true)
  if miniboss ~= nil then
    miniboss:set_enabled(false)
  end
end

function map:on_opening_transition_finished(destination)

  -- show the welcome message
  if destination == from_outside then
    game:start_dialog("dungeon_2")
  end
end

function start_miniboss_sensor:on_activated()

  if not game:get_value("b92") and not fighting_miniboss then
    -- the miniboss is alive
    map:close_doors("miniboss_door")
    hero:freeze()
    sol.timer.start(1000, function()
      sol.audio.play_music("boss")
      miniboss:set_enabled(true)
      hero:unfreeze()
    end)
    fighting_miniboss = true
  end
end

if miniboss ~= nil then
  function miniboss:on_dead()

    sol.audio.play_music("light_world_dungeon")
    map:open_doors("miniboss_door")
  end
end

function barrier_switch:on_activated()

  map:move_camera(120, 536, 250, function()
    sol.audio.play_sound("secret")
    barrier:set_enabled(false)
    game:set_value("b78", true)
  end)
end

function pegasus_run_switch:on_activated()

  pegasus_run_switch_2:set_activated(true)
  map:move_camera(904, 88, 250, function()
    sol.audio.play_sound("secret")
    pegasus_run_barrier:set_enabled(false)
  end)
  camera_back_start_timer = true
end

function pegasus_run_switch_2:on_activated()

  sol.audio.play_sound("door_open")
  pegasus_run_barrier:set_enabled(false)
  pegasus_run_switch:set_activated(true)
end

function left_eye_switch:on_activated()
  check_eye_statues()
end

function right_eye_switch:on_activated()
  check_eye_statues()
end

function map:on_camera_back()

  if camera_back_start_timer then
    camera_back_start_timer = false
    local timer = sol.timer.start(7000, function()
      sol.audio.play_sound("door_closed")
      sol.timer.start(10, function()
        if pegasus_run_barrier:overlaps(hero) then
          return true -- Repeat the timer.
        else
          pegasus_run_barrier:set_enabled(true)
        end
      end)
      pegasus_run_switch:set_activated(false)
      pegasus_run_switch_2:set_activated(false)
    end)
    timer:set_with_sound(true)
  end
end

