local map = ...
local game = map:get_game()
-- Broken rupee house

local function give_flippers()
  hero:start_treasure("flippers", 1, "b157")
end

function game_1_man:on_interaction()

  if not game:get_value("b156") then
    game:start_dialog("rupee_house_broken.help_us_left")
  elseif not game:get_value("b157") then
    game:start_dialog("rupee_house_broken.thanks", give_flippers)
  else
    game:start_dialog("rupee_house_broken.thanks_again")
  end
end

function game_2_man:on_interaction()

  if not game:get_value("b156") then
    game:start_dialog("rupee_house_broken.help_us_middle")
  elseif not game:get_value("b157") then
    game:start_dialog("rupee_house_broken.thanks", give_flippers)
  else
    game:start_dialog("rupee_house_broken.thanks_again")
  end
end

function game_3_man:on_interaction()

  if not game:get_value("b156") then
    game:start_dialog("rupee_house_broken.help_us_right")
  elseif not game:get_value("b157") then
    game:start_dialog("rupee_house_broken.thanks", give_flippers)
  else
    game:start_dialog("rupee_house_broken.thanks_again")
  end
end

