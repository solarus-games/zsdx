local map = ...
-- Dungeon 8 hidden room

function map:on_opening_transition_finished(destination)
  if destination == from_billy_cave then
    map:start_dialog("dungeon_8.welcome")
  end
end

