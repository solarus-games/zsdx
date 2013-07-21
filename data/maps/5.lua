local map = ...
local game = map:get_game()
-- Outside world B4

function map:on_started(destination)

  -- enable dark world
  if game:get_value("b905") then
    sol.audio.play_music("dark_world")
    map:set_tileset(13)
  else
    sol.audio.play_music("overworld")
  end

  -- don't allow to go to the surprise wall before dungeon 3 is finished
  if not game:is_dungeon_finished(3) then
    surprise_wall_guy:remove()
  end

  if game:get_value("b136") then
    surprise_wall_door_tile:set_enabled(false)
    surprise_wall_door:remove()
  end
end

function surprise_wall_guy:on_interaction()

  if surprise_wall_door_tile:is_enabled() then
    game:start_dialog("outside_world.surprise_wall_guy.closed", function()
      if game:get_item("level_4_way"):get_variant() == 1 then
        -- the player has the apple pie
        game:start_dialog("outside_world.surprise_wall_guy.give_me_apple_pie", function(answer)
          if answer == 1 then
            game:get_item("level_4_way"):set_variant(0)
            game:start_dialog("outside_world.surprise_wall_guy.thanks", function()
              surprise_wall_door_tile:set_enabled(false)
              surprise_wall_door:remove()
              game:set_value("b136", true)
              sol.audio.play_sound("secret")
              sol.audio.play_sound("door_open")
            end)
          end
        end)
      end
    end)
  else
    game:start_dialog("outside_world.surprise_wall_guy.open")
  end
end

function surprise_wall_door:on_interaction()
  game:start_dialog("outside_world.surprise_wall_closed")
end

