local game = ...

local dialog_box = {

  -- Dialog box properties.
  dialog = nil,                -- Dialog being displayed or nil.
  first = true,                -- Whether this is the first dialog of a sequence.
  style = nil,                 -- "box" or "empty".
  vertical_position = "auto",  -- "auto", "top" or "bottom".
  skip_mode = nil,             -- "none", "current", "all" or "unchanged".
  icon_index = nil,            -- Index of the 16x16 icon in hud/dialog_icons.png or nil.
  info = nil,                  -- Parameter passed to start_dialog().
  skipped = false,             -- Whether the player skipped the dialog.
  selected_answer = nil,       -- Selected answer (1 or 2) or nil if there is no question.

  -- Displaying text gradually.
  lines_remaining = false,     -- Whethere there are remaining lines to display.
  line_it = nil,               -- Iterator over of all lines of the dialog.
  visible_lines = {},          -- Array of the text of the 3 visible lines.
  line_surfaces = {},          -- Array of the 3 text surfaces.
  line_index = nil,            -- Line currently being shown.
  char_index = nil,            -- Next character to show in the current line.
  char_delay = nil,            -- Delay between two characters in milliseconds.

  -- Graphics.
  dialog_surface = nil,
  box_background_img = nil,
  icons_img = nil,
  end_lines_sprite = nil,
  box_dst_position = nil,      -- Destination coordinates of the dialog box.
  question_dst_position = nil, -- Destination coordinates of the question icon.
  icon_dst_position = nil,     -- Destination coordinates of the icon.
}

-- Constants.
local nb_visible_lines = 3     -- Maximum number of lines in the dialog box.
local char_delays = {
  slow = 60,
  medium = 45,
  fast = 30  -- Default.
}

-- Initializes the dialog box system.
function game:initialize_dialog_box()

  game.dialog_box = dialog_box

  -- Initialize dialog box data.
  for i = 1, nb_visible_lines do
    dialog_box.visible_lines[i] = ""
    dialog_box.line_surfaces[i] = sol.text_surface.create{
      horizontal_alignment = "left",
      vertical_alignment = "top",
      font = "dialog",
    }
  end
  dialog_box.dialog_surface = sol.surface.create(sol.video.get_quest_size())
  dialog_box.dialog_surface:set_transparency_color{0, 0, 0}
  dialog_box.box_background_img = sol.surface.create("hud/dialog_box.png")
  dialog_box.icons_img = sol.surface.create("hud/dialog_icons.png")
  dialog_box.end_lines_sprite = sol.sprite.create("hud/dialog_box_message_end")
  game:set_dialog_style("box")
end

-- Exits the dialog box system.
function game:quit_dialog_box()

  if dialog_box ~= nil then
    if game:is_dialog_enabled() then
      sol.menu.stop(dialog_box)
    end
    game.dialog_box = nil
  end
end

-- Called by the engine when a dialog starts.
function game:on_dialog_started(dialog, info)

  dialog_box.dialog = dialog
  dialog_box.info = info
  sol.menu.start(game, dialog_box)
end

-- Called by the engine when a dialog finishes.
function game:on_dialog_finished(dialog)

  sol.menu.stop(dialog_box)
  dialog_box.dialog = nil
  dialog_box.info = nil
end

-- Sets the style of the dialog box for subsequent dialogs.
-- style must be one of:
-- - "box" (default): Usual dialog box.
-- - "empty": No decoration.
function game:set_dialog_style(style)

  dialog_box.style = style
  if style == "box" then
    -- Make the dialog box slightly transparent.
    dialog_box.dialog_surface:set_opacity(216)
  end
end

-- Sets the vertical position of the dialog box for subsequent dialogs.
-- vertical_position must be one of:
-- - "auto" (default): Choose automatically so that the hero is not hidden.
-- - "top": Top of the screen.
-- - "bottom": Botton of the screen.
function game:set_dialog_position(vertical_position)
  dialog_box.vertical_position = vertical_position
end

-- A dialog starts.
function dialog_box:on_started()

  if self.first then
    -- Set the initial properties.
    -- Subsequent dialogs in the same sequence do not reset them.
    self.icon_index = nil
    self.skip_mode = "none"
    self.char_delay = char_delays["fast"]
    self.selected_answer = nil
  end

  -- Initialize this dialog.
  local dialog = self.dialog
  self.lines_remaining = true
  self.line_it = dialog.text:gmatch("[^\n\r]+")
  self.line_index = 1
  self.char_index = 1
  self.skipped = false

  if dialog.skip ~= nil then
    -- The skip mode changes for this dialog.
    self.skip_mode = dialog.skip
  end

  if dialog.icon ~= nil then
    -- The icon changes for this dialog ("-1" means none).
    if dialog.icon == "-1" then
      self.icon_index = nil
    else
      self.icon_index = dialog.icon
    end
  end

  if dialog.question == "1" then
    -- This dialog is a question.
    self.selected_answer = 1
  end

  if first then
    -- Determine the position of the dialog box on the screen.
    local map = game:get_map()
    local camera_x, camera_y, camera_width, camera_height = map:get_camera_position()
    local top = false
    if self.vertical_position == "top" then
      top = true
    elseif self.vertical_position == "auto" then
      local hero_x, hero_y = map:get_entity("hero"):get_position()
      if hero_y >= camera_y + (camera_height / 2 + 10) then
        top = true
      end
    end

    -- Set the coordinates of graphic objects.
    local x = camera_width / 2 - 110
    local y = top and 32 or (camera_height - 96)

    if self.style == "empty" then
      y = y + (top and -24 or 24)
    end

    box_dst_position = { x = x, y = y }
    question_dst_position = { x = x + 18, y = y + 27 }
    icon_dst_position = { x = x + 18, y = y + 22 }
  end

  -- Start displaying text.
  self:show_more_lines()
end

-- Returns whether there are more lines remaining to display after the current
-- 3 lines.
function dialog_box:has_more_lines()
  return self.lines_remaining
end

-- Starts showing a new group of 3 lines in the dialog (if there are
-- remaining lines).
function dialog_box:show_more_lines()

  if not has_more_lines() then
    self:show_next_dialog()
    return
  end

  -- Hide the action icon and change the sword icon.
  game:set_command_effect("action", nil)
  if self.skip_mode ~= "none" then
    game:set_custom_command_effect("attack", "skip")
    game:set_command_effect("action", "next")
  else
    game:set_command_effect("attack", nil)
  end

  -- TODO
end

function dialog_box:show_all_now()

end

function dialog_box:on_command_pressed(command)

  -- Don't propagate the event to anything below the dialog box.
  return true
end

function dialog_box:on_draw(dst_surface)

  -- TODO
end

