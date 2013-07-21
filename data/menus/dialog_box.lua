local game = ...

local dialog_box = {}

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

function dialog_box:on_draw(dst_surface)

  if self.game:is_dialog_enabled() then
    -- TODO
  end
end

