local map = ...
local game = map:get_game()

-- Intro script.

local fresco_index = 0  -- Index of the current fresco.
local fresco_sprite = nil

local function next_fresco()

  if fresco_index < 6 then
    fresco_index = fresco_index + 1
    game:start_dialog("intro" .. fresco_index, function()
      fresco_sprite:fade_out()
      sol.timer.start(600, next_fresco)
    end)
    fresco_sprite:set_animation(fresco_index)
    fresco_sprite:fade_in()
  else
    game:set_dialog_style("box")
    hero:teleport(28, "from_intro")
  end
end

function map:on_started(destination)
  hero:freeze()
  game:set_hud_enabled(false)
  game:set_pause_allowed(false)
  game:set_dialog_style("empty")
  fresco_sprite = fresco:get_sprite()
  fresco_sprite:set_ignore_suspend(true)
  game:start_dialog("intro0", function()
    black_screen:set_enabled(false)
    sol.audio.play_music("legend")
    next_fresco()
  end)
end

