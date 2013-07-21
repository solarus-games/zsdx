local map = ...
local game = map:get_game()
-- Dungeon 8 hidden room

function map:on_opening_transition_finished(destination)
  if destination == from_billy_cave then
    game:start_dialog("dungeon_8.welcome")
  end
end

