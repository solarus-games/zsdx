local game = ...

local dialog_box = {
  style = "box",
  position = "auto",
}

function game:initialize_dialog_box()

  game.dialog_box = dialog_box
  dialog_box.game = game
end

function game:quit_dialog_box()

  if dialog_box ~= nil then
    if game:is_dialog_enabled() then
      sol.menu.stop(dialog_box)
    end
    game.dialog_box = nil
  end
end

function game:on_dialog_started(dialog, info)

  dialog_box.dialog = dialog
  sol.menu.start(game, dialog_box)
end

function game:on_dialog_finished()

  sol.menu.stop(dialog_box)
  dialog_box.dialog = nil
end

-- Sets the style of the dialog box for subsequent dialogs.
-- style must be one of:
-- - "box" (default): Usual dialog box.
-- - "empty": No decoration.
function game:set_dialog_style(style)
  dialog_box.style = style
end

-- Sets the vertical position of the dialog box for subsequent dialogs.
-- position must be one of:
-- - "auto" (default): Choose automatically so that the hero is not hidden.
-- - "top": Top of the screen.
-- - "bototm": Botton of the screen.
function game:set_dialog_position(position)
  dialog_box.position = position
end

function dialog_box:on_command_pressed(command)

  -- Don't propagate the event to anything below the dialog box.
  return true
end

function dialog_box:on_draw(dst_surface)

  -- TODO
end

