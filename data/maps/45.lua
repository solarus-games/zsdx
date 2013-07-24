local map = ...
local game = map:get_game()
-- Surprise wall

local next_sign = 1
local directions = {
  0, 1, 2, 1, 2, 1, 0, 3, 0, 1, 0, 3, 0, 1, 2, 3,
  0, 1, 2, 1, 0, 1, 2, 3, 2, 1, 0, 3, 0, 1, 0
}

function map:on_started(destination)

  if game:get_value("b139") then
    secret_way:set_enabled(false)
  end
end

for sign in map:get_entities("sign_") do
  function sign:on_interaction()

    if self:get_name() == "sign_" .. next_sign then

      if next_sign < 32 then
        game:start_dialog("surprise_wall.direction_" .. directions[next_sign])
      elseif next_sign == 32 then
        sol.audio.play_sound("secret")
	secret_way:set_enabled(false)
	game:set_value("b139", true)
      end
      next_sign = next_sign + 1
    else
      sol.audio.play_sound("wrong")
      next_sign = 1
    end
  end
end

