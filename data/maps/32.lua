local map = ...
local game = map:get_game()
-- Telepathic booth

function hint_stone:on_interaction()

  if not game:is_dungeon_finished(1) then
    game:start_dialog("telepathic_booth.not_working")
  elseif not game:has_item("bow") then
    game:start_dialog("telepathic_booth.go_sahasrahla", game:get_player_name())
  elseif not game:is_dungeon_finished(2) then
    game:start_dialog("telepathic_booth.go_twin_caves", game:get_player_name())
  elseif not game:get_item("rupee_bag"):has_variant(2) then
    game:start_dialog("telepathic_booth.dungeon_2_not_really_finished", game:get_player_name())
  elseif not game:is_dungeon_finished(3) then
    game:start_dialog("telepathic_booth.go_master_arbror", game:get_player_name())
  elseif not game:is_dungeon_finished(4) then
    game:start_dialog("telepathic_booth.go_billy", game:get_player_name())
  else
    game:start_dialog("telepathic_booth.shop", game:get_player_name())
  end
end

