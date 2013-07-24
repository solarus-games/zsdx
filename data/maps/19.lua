local map = ...
local game = map:get_game()
-- Cake shop

local function has_talked_about_apples()
  return game:get_value("b46")
end

local function has_obtained_bottle()
  return game:get_value("b32")
end

local function apples_question_finished(answer)

  game:set_value("b46", true)

  if answer == 1 then
    if game:has_item("apples_counter") then
      if game:get_item("apples_counter"):has_amount(6) then
        game:start_dialog("cake_shop.thank_you", function()
          hero:start_treasure("bottle_1", 1, "b32")
        end)
        game:get_item("apples_counter"):remove_amount(6)
      else
        game:start_dialog("cake_shop.not_enough_apples")
      end
    else
      game:start_dialog("cake_shop.no_apples")
    end
  end
end

local function talk_to_seller()

  if not has_talked_about_apples() or has_obtained_bottle() then
    game:start_dialog("cake_shop.seller.choose_item")
  else
    game:start_dialog("cake_shop.seller.ask_apples_again", apples_question_finished)
  end
end

function map:on_started(destination)

  if not has_obtained_bottle() or not game:is_dungeon_finished(1) then
    apple_pie:remove()
  end
end

function leaving_shop_sensor:on_activated()

  if not has_obtained_bottle() and not has_talked_about_apples() then
    game:start_dialog("cake_shop.dont_leave", apples_question_finished)
  end
end

function seller_talking_place:on_interaction()
  talk_to_seller()
end

function seller:on_interaction()
  talk_to_seller()
end

