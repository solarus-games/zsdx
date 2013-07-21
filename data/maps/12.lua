local map = ...
local game = map:get_game()
-- Sahasrahla house

local function has_obtained_world_map()
  return game:get_value("b33")
end

local function has_seen_frozen_door()
  return game:get_value("b34")
end

local function has_open_frozen_door()
  return game:get_value("b35")
end

local function has_obtained_clay_key()
  return game:get_value("b28")
end

local function has_obtained_bow()
  return game:get_value("b26")
end

local function give_world_map()
  hero:start_treasure("world_map", 1, "b33", function()
    game:start_dialog("sahasrahla_house.quest_accepted", function()
      if not door:is_open() then
        map:open_doors("door")
      end
    end)
  end)
end

function map:on_started(destination)

  if game:get_value("b37") then -- if the Lyriann cave is finished
    map:set_doors_open("door", game:is_dungeon_finished(1)) -- don't allow the player to obtain the bow until the first dungeon is finished
  end

  if game:is_dungeon_finished(4)
      and not game:is_dungeon_finished(7) then
    -- Sahasrahla has been kidnapped
    sahasrahla:remove()
  end
end

-- The player talks to Sahasrahla
function sahasrahla:on_interaction()

  if not has_obtained_clay_key() then

    if not has_obtained_world_map() then
      -- first visit
      game:start_dialog("sahasrahla_house.beginning", game:get_player_name(), give_world_map)

    elseif has_seen_frozen_door() and not has_open_frozen_door() then
      -- the player has seen the frozen door but was not able to unfreeze it
      game:start_dialog("sahasrahla_house.frozen_door_advice")

    else
      -- the player has not found the clay key yet
      game:start_dialog("sahasrahla_house.quest_accepted", function()
        if not door:is_open() then
          map:open_doors("door")
        end
      end)
    end

  elseif not has_obtained_world_map() then
    -- the player has obtained the clay key: give him the world map now if he didn't talk the first time
    game:start_dialog("sahasrahla_house.give_world_map", give_world_map)
  elseif game:is_dungeon_finished(1) and not has_obtained_bow() then -- glove
    -- the player should now go downstairs to obtain the bow
    game:start_dialog("sahasrahla_house.dungeon_1_finished")
  else
    -- Sahsrahla has nothing special to sayhero
    game:start_dialog("sahasrahla_house.default")
  end
end

