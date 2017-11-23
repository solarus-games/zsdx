return function(game)

  local inventory_builder = require("menus/pause_inventory")
  local map_builder = require("menus/pause_map")
  local quest_status_builder = require("menus/pause_quest_status")
  local options_builder = require("menus/pause_options")
  local last_joy_axis_move = { 0, 0 }

  function game:start_pause_menu()

    self.pause_submenus = {
      inventory_builder:new(self),
      map_builder:new(self),
      quest_status_builder:new(self),
      options_builder:new(self),
    }

    local submenu_index = self:get_value("pause_last_submenu") or 1
    if submenu_index <= 0
        or submenu_index > #self.pause_submenus then
      submenu_index = 1
    end
    self:set_value("pause_last_submenu", submenu_index)

    sol.audio.play_sound("pause_open")
    sol.menu.start(self, self.pause_submenus[submenu_index], false)
  end

  function game:stop_pause_menu()

    sol.audio.play_sound("pause_closed")
    local submenu_index = self:get_value("pause_last_submenu")
    sol.menu.stop(self.pause_submenus[submenu_index])
    self.pause_submenus = {}
    self:set_custom_command_effect("action", nil)
    self:set_custom_command_effect("attack", nil)
  end

  function game:on_joypad_axis_moved(axis, state)

    -- Avoid move repetition
    local handled = last_joy_axis_move[axis % 2] == state
    last_joy_axis_move[axis % 2] = state

    return handled
  end

end
