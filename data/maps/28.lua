local map = ...
local game = map:get_game()
-- Link's house

local function jump_from_bed()
  hero:set_visible(true)
  hero:start_jumping(4, 24, true)
  game:set_pause_allowed(true)
  bed:get_sprite():set_animation("empty_open")
  sol.audio.play_sound("hero_lands")
end

local function wake_up()
  snores:remove()
  bed:get_sprite():set_animation("hero_waking")
  sol.timer.start(500, function()
    jump_from_bed()
  end)
end

function map:on_started(destination)

  if destination == from_intro then
    -- the intro scene is playing
    game:set_hud_enabled(true)
    game:set_pause_allowed(false)
    game:set_dialog_style("box")
    snores:get_sprite():set_ignore_suspend(true)
    bed:get_sprite():set_animation("hero_sleeping")
    hero:freeze()
    hero:set_visible(false)
    sol.timer.start(2000, function()
      game:start_dialog("link_house.dream", game:get_player_name(), function()
        sol.timer.start(1000, wake_up)
      end)
    end)
  else
    snores:remove()
  end
end

function weak_wall:on_opened()

  sol.audio.play_sound("secret")
end


