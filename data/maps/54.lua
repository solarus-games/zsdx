local map = ...
local game = map:get_game()
-- Dungeon 3 5F

function map:on_opening_transition_finished(destination)

  -- show the welcome message
  if destination == from_above_tree then
    game:start_dialog("dungeon_3")
  end
end

