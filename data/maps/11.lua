local map = ...
local game = map:get_game()
-- Grandma house

-- The player talks to grandma
function grandma:on_interaction()

  local has_smith_sword = game:get_value("b30")
  local has_clay_key = game:get_value("b28")
  local has_finished_lyriann_cave = game:get_value("b37")
  local has_bow = game:get_value("b26")
  local has_rock_key = game:get_value("b68")

  if not has_smith_sword then
    -- beginning: go get a sword
    game:start_dialog("grandma_house.sword")
  elseif not has_clay_key then
    -- with the sword: find Sahasrahla
    game:start_dialog("grandma_house.find_sahasrahla")
  elseif not has_finished_lyriann_cave then
    -- with the clay key: go to the cave
    game:start_dialog("grandma_house.go_lyriann_cave")
  elseif not game:is_dungeon_finished(1) then
    -- lyriann cave finished: go to the first dungeon
    game:start_dialog("grandma_house.go_dungeon_1")
  elseif not has_bow then
    -- dungeon 1 finished: go to Sahasrahla's house
    game:start_dialog("grandma_house.go_back_sahasrahla")
  elseif not has_rock_key then
    -- with the bow: go to the twin caves
    game:start_dialog("grandma_house.go_twin_caves")
  elseif not game:is_dungeon_finished(2) then
    -- with the rock key: go to the second dungeon
    game:start_dialog("grandma_house.go_dungeon_2")
  elseif not game:is_dungeon_finished(4) then
    -- use the telepathic booth
    game:start_dialog("grandma_house.go_telepathic_booth")
  elseif not game:is_dungeon_finished(5) then
    -- rupee house broken
    game:start_dialog("grandma_house.dark_world_enabled")
  else
    -- use the telepathic booth again
    game:start_dialog("grandma_house.go_telepathic_booth")
  end

end
