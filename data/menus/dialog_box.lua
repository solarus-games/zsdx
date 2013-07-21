local game = ...

local dialog_box = {
  style = "box",
  position = "auto",
}

function game:initialize_dialog_box()

  game.dialog_box = dialog_box
  dialog_box.game = game
  sol.menu.start(game, dialog_box)
end

function game:quit_dialog_box()

  if dialog_box ~= nil then
    sol.menu.stop(dialog_box)
    game.dialog_box = nil
  end
end

function game:on_dialog_started(dialog, info)
  -- TODO
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

function dialog_box:on_draw(dst_surface)

  if self.game:is_dialog_enabled() then
    -- TODO
  end
end

