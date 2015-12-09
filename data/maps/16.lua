local map = ...
local game = map:get_game()
-- Smith cave

local sword_price = 75

-- Function called when the player wants to talk to a non-playing character.
function smith:on_interaction()

  -- smith dialog
  if not game:get_value("b30") then
    -- the player has no sword yet
    game:start_dialog("smith_cave.without_sword", function(answer)
      -- the dialog was the question to buy the sword

      if answer == 2 then
        -- the player does not want to buy the sword
        game:start_dialog("smith_cave.not_buying")
      else
        -- wants to buy the sword
        if game:get_money() < sword_price then
          -- not enough money
          sol.audio.play_sound("wrong")
          game:start_dialog("smith_cave.not_enough_money")
        else
          -- enough money: buy the sword
          game:remove_money(sword_price)
          sol.audio.play_sound("treasure")
          hero:start_treasure("sword", 1, "b30", function()
            game:start_dialog("smith_cave.thank_you")
          end)
        end
      end
    end)
  else
    -- the player already has the sword
    game:start_dialog("smith_cave.with_sword")
  end
end

function chest:on_opened()
  sol.audio.play_sound("wrong")
  game:start_dialog("_empty_chest")
  hero:unfreeze()
end

