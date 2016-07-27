local map = ...
-- Hidden palace end

local light_manager = require("maps/lib/light_manager")
function map:on_started(destination)

  light_manager.enable_light_features(map)
  map:set_light(0)
end

function sword_chest:on_opened()

  local variant = 2
  if map:get_game():get_ability("sword") >= 2 then
    -- already got sword 2
    variant = 3
  end
  hero:start_treasure("sword", variant)
end

function map:on_obtaining_treasure(item, variant, savegame_variable)

  if item:get_name() == "sword" then
    sol.audio.play_music("excalibur")
  end
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "sword" then
    hero:start_victory(function()
      hero:unfreeze()
      sol.audio.play_music("light_world_dungeon")
    end)
  end
end

