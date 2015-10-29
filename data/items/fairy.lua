local item = ...
local game = item:get_game()

-- This script defines the behavior of pickable fairies present on the map.

function item:on_created()

  self:set_shadow(nil)
  self:set_can_disappear(true)
  self:set_brandish_when_picked(false)
end

-- A fairy appears on the map: create its movement.
function item:on_pickable_created(pickable)

   -- Create a movement that goes into random directions,
   -- with a speed of 28 pixels per second.
  local movement = sol.movement.create("random")
  movement:set_speed(28)
  movement:set_ignore_obstacles(true)
  movement:set_max_distance(40)  -- Don't go too far.

  -- Put the fairy on the highest layer to show it above all walls.
  local x, y = pickable:get_position()
  pickable:set_position(x, y, 2)
  pickable:set_layer_independent_collisions(true)  -- But detect collisions with lower layers anyway

  -- When the direction of the movement changes,
  -- update the direction of the fairy's sprite
  function pickable:on_movement_changed(movement)

    if pickable:get_followed_entity() == nil then

      local sprite = pickable:get_sprite()
      local angle = movement:get_angle()  -- Retrieve the current movement's direction.
      if angle >= math.pi / 2 and angle < 3 * math.pi / 2 then
        sprite:set_direction(1)  -- Look to the left.
      else
        sprite:set_direction(0)  -- Look to the right.
      end
    end
  end

  movement:start(pickable)
end

-- Obtaining a fairy.
function item:on_obtaining(variant, savegame_variable)

  if not self:get_game():has_bottle() then
    -- The player has no bottle: just restore 7 hearts.
    game:add_life(7 * 4)
  else
    -- The player has a bottle: start the dialog.
    game:start_dialog("found_fairy", function(answer)

      if answer == "skipped" or answer == 1 then
        -- Restore 7 hearts.
        if game:get_life() == game:get_max_life() then
          -- Life is already full: we still play a sound to indicate
          -- that the fairy was picked.
          -- Otherwise it looks like if nothing happened.
          sol.audio.play_sound("picked_item")
        else
          game:add_life(7 * 4)
        end
      else
        -- Keep the fairy in a bottle.
        local first_empty_bottle = self:get_game():get_first_empty_bottle()
        if first_empty_bottle == nil then
          -- No empty bottle.
          game:start_dialog("found_fairy.no_empty_bottle", function()
            game:add_life(7 * 4)
          end)
          sol.audio.play_sound("wrong")
        else
          -- Okay, empty bottle.
          first_empty_bottle:set_variant(6)
          sol.audio.play_sound("danger")
        end
      end
    end)
  end
end

