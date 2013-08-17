-- This script adds to a map some functions that allow you to put the map
-- into the dark.
--
-- Your map will have the following new functions:
-- map:get_light(), map:set_light() and the event map:on_draw().
--
-- Usage:
--
-- local light_manager = require("maps/lib/light_manager")
--
-- function your_map:on_started()
--   light_manager.enable_light_features(your_map)
-- end
--
-- -- Later:
-- your_map:set_light(0)  -- Put the map into the dark.
-- your_map:set_light(1)  -- Restore normal light.

local light_manager = {}

-- Dark overlay for each hero direction.
local dark_surfaces = {
  [0] = sol.surface.create("entities/dark0.png"),
  [1] = sol.surface.create("entities/dark1.png"),
  [2] = sol.surface.create("entities/dark2.png"),
  [3] = sol.surface.create("entities/dark3.png")
}
local black = {0, 0, 0}

function light_manager.enable_light_features(map)

  map.light = 1
  map.get_light = function(map)
    return map.light
  end

  map.set_light = function(map, light)
    map.light = light
  end

  map.on_draw = function(map, dst_surface)

    if map.light ~= 0 then
      -- Normal light: nothing special to do.
      return
    end

    -- Dark room.
    local screen_width, screen_height = dst_surface:get_size()
    local hero = map:get_entity("hero")
    local hero_x, hero_y = hero:get_center_position()
    local camera_x, camera_y = map:get_camera_position()
    local x = 320 - hero_x + camera_x
    local y = 240 - hero_y + camera_y
    local dark_surface = dark_surfaces[hero:get_direction()]
    dark_surface:draw_region(
        x, y, screen_width, screen_height, dst_surface)

    -- dark_surface may be too small if the screen size is greater
    -- than 320x240. In this case, add black bars.
    if x < 0 then
      dst_surface:fill_color(black, 0, 0, -x, screen_height)
    end

    if y < 0 then
      dst_surface:fill_color(black, 0, 0, screen_width, -y)
    end

    local dark_surface_width, dark_surface_height = dark_surface:get_size()
    if x > dark_surface_width - screen_width then
      dst_surface:fill_color(black, dark_surface_width - x, 0,
          x - dark_surface_width + screen_width, screen_height)
    end

    if y > dark_surface_height - screen_height then
      dst_surface:fill_color(black, 0, dark_surface_height - y,
          screen_width, y - dark_surface_height + screen_height)
    end
  end
end

return light_manager

