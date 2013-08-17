local map = ...
-- Beaumont cave: Inferno maze

local light_manager = require("maps/lib/light_manager")

function map:on_started(destination)

  -- Enable small keys on this map.
  map.small_keys_savegame_variable = "i1200"

  light_manager.enable_light_features(map)
  map:set_light(0)
end


