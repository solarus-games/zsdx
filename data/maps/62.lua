local map = ...
local game = map:get_game()
-- Dungeon 4 icy room

function map:on_opening_transition_finished(destination)

  if not game:get_item("tunic"):has_variant(2) then

    game:start_dialog("dungeon_4.too_cold", function()
      hero:walk("2222", false, true)
    end)
  end
end

