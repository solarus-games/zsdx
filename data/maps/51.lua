local map = ...
-- Dungeon 8 B4

-- Legend
-- CB: Chest Button
-- RC: Rupee Chest
-- KC: Key Chest
-- KP: Key Pot
-- LD: Locked Door
-- KD: Key Door
-- DB: Door Button
-- LB: Locked Barrier
-- BB: Barrier Button
-- DS: Door Sensor

local light_manager = require("maps/lib/light_manager")
local dont_close_LD06 = false

function map:on_started()

  light_manager.enable_light_features(map)
  map:set_light(0)
  if not map:get_game():get_value("b725") then
    STT5:set_enabled(false)
    from_hole_tile:set_enabled(false)
  end
end

function DB03:on_activated()

  if DB04:is_activated()
      and not LD06:is_open() then
    map:open_doors("LD06")
  end
end

function DB04:on_activated()

  if DB03:is_activated()
      and not LD06:is_open() then
    map:open_doors("LD06")
  end
end

function DB03:on_inactivated()

  if not LD06:is_closed() and not dont_close_LD06 then
    map:close_doors("LD06")
  end
end
DB04.on_inactivated = DB03.on_inactivated

function dont_close_LD06_sensor:on_activated()
  dont_close_LD06 = true
end

