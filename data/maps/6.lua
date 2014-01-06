local map = ...
local game = map:get_game()
-- Outside world A4

local tom_sprite = nil

local function is_ladder_activated()
  return game:get_value("b52")
end

local function is_beaumont_cave_open()
  return game:get_value("b153")
end

function map:on_started(destination)

  -- enable dark world
  if game:get_value("b905") then
    sol.audio.play_music("dark_world")
    map:set_tileset(13)
  else
    sol.audio.play_music("overworld")
  end

  -- dungeon 1 ladder
  if is_ladder_activated() then
    map:set_entities_enabled("ladder_step", true)
    map:set_entities_enabled("no_ladder", false)
    tom:remove()
    tom_appears_sensor:set_enabled(false)
  else
    map:set_entities_enabled("ladder_step", false)
    map:set_entities_enabled("no_ladder", true)
    tom_sprite = tom:get_sprite()
  end

  -- Beaumont cave entrance
  if not is_beaumont_cave_open() then
    beaumont_cave_hole:set_enabled(false)
    to_beaumont_cave:set_enabled(false)
  end

  -- Dungeon 9 entrance
  if not game:is_dungeon_finished(8) then
    dungeon_9_teletransporter:set_enabled(false)
    dungeon_9_entrance:set_enabled(false)
  end
end

function tom_appears_sensor:on_activated()

  local has_finished_tom_cave = game:get_value("b37")
  if has_finished_tom_cave
      and not is_ladder_activated() then
    game:start_dialog("outside_world.tom_dungeon_1_entrance.hey", function()
      hero:freeze()
      hero:set_direction(0)
      tom:set_position(528, 245)
      local m = sol.movement.create("path")
      m:set_path{4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,2,2}
      m:set_speed(48)
      m:set_ignore_obstacles(true)
      m:start(tom)
    end)
  end
end

function edelweiss_sensor:on_activated()

  if game:get_item("level_4_way"):get_variant() == 3  -- the player has the edelweiss
      and not is_beaumont_cave_open() then
    game:start_dialog("outside_world.beaumont_hill_put_edelweiss", function()
      hero:freeze()
      sol.timer.start(1000, function()
        sol.audio.play_sound("explosion")
        map:create_explosion{
	  x = 160,
	  y = 72,
	  layer = 0
	}
        beaumont_cave_hole:set_enabled(true)
        to_beaumont_cave:set_enabled(true)
        game:set_value("b153", true)
        game:get_item("level_4_way"):set_variant(0)
        sol.timer.start(1000, function()
          sol.audio.play_sound("secret")
          hero:unfreeze()
        end)
      end)
    end)
  end
end

function tom:on_movement_finished()

  local x, y = tom:get_position()
  if x ~= 352 then
    tom_sprite:set_direction(2)
    game:start_dialog("outside_world.tom_dungeon_1_entrance.need_help", function()
      tom_sprite:set_direction(1)
      sol.timer.start(1500, function()
	game:start_dialog("outside_world.tom_dungeon_1_entrance.let_me_see", function()
	  sol.audio.play_sound("jump")
	  local m = sol.movement.create("jump")
	  m:set_direction8(4)
	  m:set_distance(16)
	  m:set_ignore_obstacles(true)
          m:start(tom)
	end)
      end)
  tom_sprite:set_direction(2)
    end)
  else
    tom_sprite:set_direction(1)
    sol.timer.start(1000, function()
      game:start_dialog("outside_world.tom_dungeon_1_entrance.open", function()
	tom_sprite:set_animation("walking")
	sol.timer.start(300, function()
	  tom_sprite:set_animation("stopped")
	  sol.audio.play_sound("door_open")
	  map:set_entities_enabled("ladder_step1", true)
	  map:set_entities_enabled("no_ladder_step1", false)
	  sol.timer.start(1000, function()
	    sol.audio.play_sound("door_open")
	    map:set_entities_enabled("ladder_step2", true)
	    sol.timer.start(1000, function()
	      sol.audio.play_sound("door_open")
	      map:set_entities_enabled("ladder_step3", true)
	      sol.timer.start(1000, function()
		map:set_entities_enabled("no_ladder", false)
		tom_appears_sensor:set_enabled(false)
		sol.audio.play_sound("secret")
		game:set_value("b52", true)
		hero:unfreeze()
	      end)
	    end)
	  end)
	end)
      end)
    end)
  end
end

function tom:on_interaction()
  game:start_dialog("outside_world.tom_dungeon_1_entrance.finished")
end

