local map = ...
local game = map:get_game()
-- Hidden palace D1

function map:on_started(destination)

  map:set_light(0)

  if game:get_value("b934") then
    bone_key_door:remove()
  end
end

-- Function called when the player presses the action key on the door
function bone_key_door:on_interaction()

  if not game:has_item("bone_key") then
    game:start_dialog("hidden_palace.door_closed")
  else
    game:start_dialog("hidden_palace.using_bone_key", function()
      sol.audio.play_sound("door_open")
      sol.audio.play_sound("door_unlocked")
      sol.audio.play_sound("secret")
      bone_key_door:remove()
      game:set_value("b934", true)
    end)
  end
end

