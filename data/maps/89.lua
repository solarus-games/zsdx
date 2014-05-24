local map = ...
local game = map:get_game()
-- Castle 1F

local function random_walk(npc)

  local m = sol.movement.create("random_path")
  m:set_speed(32)
  m:start(npc)
end

function map:on_started(destination)

  -- make the NPCs walk
  random_walk(walking_npc_1)
  random_walk(walking_npc_2)

  if destination == from_ending then
    -- game ending sequence
    hero:freeze()
    hero:set_visible(false)
    game:set_hud_enabled(false)
    sol.audio.play_music("fanfare")
  else
    tom:set_enabled(false)
    sol.audio.play_music("castle")
  end
end

function map:on_opening_transition_finished(destination)

  if destination == from_ending then
    game:start_dialog("credits_4", function()
      sol.timer.start(2000, function()
        hero:teleport(119, "from_ending")
      end)
    end)
    map:move_camera(288, 96, 25, function() end, 1e6)
  end
end

function forbidden_door_npc:on_interaction()

  local hero_x = hero:get_position()
  if hero_x < 832 then
    game:start_dialog("castle.forbidden_door")
  else
    game:start_dialog("castle.forbidden_door_wtf", function()
      local m = sol.movement.create("path")
      m:set_path{2,2}
      m:set_speed(32)
      m:start(self)
      hero:freeze()
    end)
  end
end

function forbidden_door_npc:on_movement_finished()

  hero:unfreeze()
  local sprite = self:get_sprite()
  if sprite:get_direction() == 1 then
    sprite:set_direction(3)
    hero:walk("4444", false, false)
  end
end

function forbidden_door_sensor:on_activated()

  local x, y = forbidden_door_npc:get_position()
  if y < 877 then
    local m = sol.movement.create("path")
    m:set_path{6,6}
    m:set_speed(32)
    m:start(forbidden_door_npc)
    hero:freeze()
  end
end

