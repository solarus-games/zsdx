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

function game:on_dialog_started(dialog)
  -- TODO
end

function dialog_box:on_draw(dst_surface)

  -- The dialog box is actually still built-in for now.
  local map = self.game:get_map()
  if map ~= nil and map:is_dialog_enabled() then
    map:draw_dialog_box(dst_surface)
  end
end

