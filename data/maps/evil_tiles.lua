-- This script enables evil tiles on the map passed as parameter.
return function(map)

  -- Starts the attack of evil tiles
  -- (this function can be called when the hero enters the room of evil tiles).
  function map:start_evil_tiles()

    local total = map:get_entities_count("evil_tile_enemy")
    local next_index = 1  -- Index of the next evil tile to spawn.
    local spawn_delay = 1500  -- Delay between two evil tiles.

    map:set_entities_enabled("evil_tile_enemy", false)
    map:set_entities_enabled("evil_tile_after", false)

    -- Spawns a tile and schedules the next one.
    local function repeat_spawn()

      map:get_entity("evil_tile_enemy_" .. next_index):set_enabled(true)
      map:get_entity("evil_tile_after_" .. next_index):set_enabled(true)
      next_index = next_index + 1
      if next_index <= total then
        sol.timer.start(spawn_delay, repeat_spawn)
      end
    end

    -- Plays a sound repeatedly as long as at least one tile is moving.
    local function repeat_sound()

      sol.audio.play_sound("walk_on_grass")

      -- Repeat the sound until the last tile starts animation "destroy".
      local again = false
      local remaining = map:get_entities_count("evil_tile_enemy")
      if remaining > 1 then
        again = true
      elseif remaining == 1 then
        for enemy in map:get_entities("evil_tile_enemy_") do
          local sprite = enemy:get_sprite()
          if sprite and sprite:get_animation() ~= "destroy" then
            again = true
            break
          end
        end
      end

      if again then
        sol.timer.start(150, repeat_sound)
      else
        if map.finish_evil_tiles ~= nil then
          map:finish_evil_tiles()
        end
      end
    end

    repeat_spawn()
    repeat_sound()
  end

end
