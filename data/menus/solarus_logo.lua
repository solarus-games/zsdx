-- This menu is displayed when the program starts, before the language screen.
-- It shows the Solarus engine logo.

local solarus_logo_menu = {}
local finished = false
local surface

local function start_next_menu()

  if sol.main.menu == solarus_logo_menu then
    local language_menu = require("menus/language")
    sol.main:start_menu(language_menu:new())
  end
end

function solarus_logo_menu:on_started()

  finished = false
  surface = sol.surface.create("menus/solarus_logo.png")
  surface:fade_in(function()

    sol.timer.start(solarus_logo_menu, 1000, function()
      if not finished then
        finished = true
        surface:fade_out()
        sol.timer.start(self, 700, start_next_menu)
      end
    end)
  end)
end

function solarus_logo_menu:on_draw(dst_surface)

  -- The logo makes 320*240 pixels, but dst_surface may be larger.
  local width, height = dst_surface:get_size()
  surface:draw(dst_surface, width / 2 - 160, height / 2 - 120)
end

function solarus_logo_menu:on_key_pressed(key)

  local handled = false

  if key == "escape" then
    -- Stop the program.
    handled = true
    sol.main.exit()

  else

    if not finished then
      handled = true
      finished = true
      surface:fade_out()
      sol.timer.start(self, 700, start_next_menu)
    end

    return handled
  end
end

function solarus_logo_menu:on_joypad_button_pressed(button)

  return solarus_logo_menu:on_key_pressed("space")
end

return solarus_logo_menu

