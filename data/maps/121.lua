local map = ...
local game = map:get_game()

function map:on_started()

  -- Open Billy's door.
  game:set_value("b928", true)
end

