local map = ...
local game = map:get_game()
-- Dungeon 8 boss

function map:on_started(destination)

  if boss ~= nil then
    boss:set_enabled(false)
  end

  ganon_npc:set_enabled(false)
  if destination == from_1F then
    if game:get_value("b728") then
      -- Agahnim already killed
      agahnim_npc:set_enabled(false)
    end
  end
end

function start_boss_sensor:on_activated()

  if not game:get_value("b728") then

    map:close_doors("boss_door")
    hero:freeze()
    sol.audio.play_music("agahnim")
    sol.timer.start(1000, function()
      game:start_dialog("dungeon_8.agahnim", function()
        hero:teleport(52, "boss_destination_point")
        sol.timer.start(100, function()
          sol.audio.play_music("ganon_battle")
          boss:set_enabled(true)
          agahnim_npc:set_enabled(false)
        end)
      end)
    end)

  elseif not game:is_dungeon_finished(8) then
    -- Agahnim already killed but Ganon's sequence not done yet
    -- (possible if the player dies or exits while Agahnim is dying)
    hero:freeze()
    sol.timer.start(100, function()
      hero:teleport(52, "ganon_dialog_destination_point")
    end)
    sol.timer.start(200, start_ganon_sequence)
  end
end

if boss ~= nil then
  function boss:on_dead()

    sol.timer.start(1000, function()
      sol.audio.play_music("victory")
      game:set_dungeon_finished(8)
      game:set_pause_allowed(false)
      hero:freeze()
      hero:set_direction(3)
      sol.timer.start(9000, function()
        hero:teleport(52, "ganon_dialog_destination_point")
      end)
      sol.timer.start(9100, function()

        hero:set_direction(1)
        hero:freeze()
        ganon_npc:set_enabled(true)

        sol.timer.start(1000, function()
          sol.audio.play_music("ganon_theme")
          game:start_dialog("dungeon_8.ganon", function()
            sol.audio.play_sound("world_warp")
            sol.timer.start(1000, function()
              game:set_pause_allowed(true)
              hero:teleport(105, "from_outside")
            end)
          end)
        end)
      end)
    end)
  end
end

