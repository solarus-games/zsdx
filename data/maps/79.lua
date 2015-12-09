local map = ...
-- Waterfall cave 1F

local nb_chests_open = 0

local function chest_empty(chest)

  nb_chests_open = nb_chests_open + 1

  if nb_chests_open == 7 then
    hero:start_treasure("piece_of_heart", 1, "b197")
  else
    sol.audio.play_sound("secret")
    hero:unfreeze()
  end
end

function map:on_started(destination)

  -- piece of heart found
  for i = 1, 7 do
    local chest = map:get_entity("chest_" .. i)
    chest.on_opened = chest_empty
    if map:get_game():get_value("b197") then
      chest:set_open(true)
    end
  end
end

