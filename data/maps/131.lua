local map = ...
-- The end

function map:on_started(destination)

  if destination == from_ending then
    hero:freeze()
    hero:set_visible(false)
    map:get_game():set_hud_enabled(false)
    map:set_pause_enabled(false)
    sol.timer.start(25000, function()
      sol.main.reset()
    end)
  end
end

