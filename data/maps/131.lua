local map = ...
local game = map:get_game()
-- The end

function map:on_started(destination)

  if destination == from_ending then
    hero:freeze()
    hero:set_visible(false)
    game:set_hud_enabled(false)
    game:set_pause_allowed(false)
    sol.timer.start(25000, function()
      sol.main.reset()
    end)
  end
end

