-- This script handles global behavior of this quest,
-- that is, things not related to a particular savegame.
local quest_manager = {}

-- Initialize map features specific to this quest.
local function initialize_map()

  local map_meta = sol.main.get_metatable("map")

  function map_meta:move_camera(x, y, speed, callback, delay_before, delay_after)

    local camera = self:get_camera()
    local game = self:get_game()
    local hero = self:get_hero()

    delay_before = delay_before or 1000
    delay_after = delay_after or 1000

    local back_x, back_y = camera:get_position_to_track(hero)
    game:set_suspended(true)
    camera:start_manual()

    local movement = sol.movement.create("target")
    movement:set_target(camera:get_position_to_track(x, y))
    movement:set_ignore_obstacles(true)
    movement:set_speed(speed)
    movement:start(camera, function()
      local timer_1 = sol.timer.start(self, delay_before, function()
        if callback ~= nil then
          callback()
        end
        local timer_2 = sol.timer.start(self, delay_after, function()
          local movement = sol.movement.create("target")
          movement:set_target(back_x, back_y)
          movement:set_ignore_obstacles(true)
          movement:set_speed(speed)
          movement:start(camera, function()
            game:set_suspended(false)
            camera:start_tracking(hero)
            if self.on_camera_back ~= nil then
              self:on_camera_back()
            end
          end)
        end)
        timer_2:set_suspended_with_map(false)
      end)
      timer_1:set_suspended_with_map(false)
    end)
  end
end

-- Initializes the behavior of destructible entities.
local function initialize_destructibles()

  -- Show a dialog when the player cannot lift them.
  local destructible_meta = sol.main.get_metatable("destructible")
  -- destructible_meta represents the shared behavior of all destructible objects.

  function destructible_meta:on_looked()

    -- Here, self is the destructible object.
    local game = self:get_game()
    if self:get_can_be_cut()
        and not self:get_can_explode()
        and not self:get_game():has_ability("sword") then
      -- The destructible can be cut, but the player has no cut ability.
      game:start_dialog("_cannot_lift_should_cut");
    elseif not game:has_ability("lift") then
      -- No lift ability at all.
      game:start_dialog("_cannot_lift_too_heavy");
    else
      -- Not enough lift ability.
      game:start_dialog("_cannot_lift_still_too_heavy");
    end
  end
end

-- Initializes the behavior of enemies.
local function initialize_enemies()

  -- Enemies: redefine the damage of the hero's sword.
  -- (The default damages are less important.)
  local enemy_meta = sol.main.get_metatable("enemy")

  function enemy_meta:on_hurt_by_sword(hero, enemy_sprite)

    -- Here, self is the enemy.
    local game = self:get_game()
    local sword = game:get_ability("sword")
    local damage_factors = { 1, 2, 4, 8 }  -- Damage factor of each sword.
    local damage_factor = damage_factors[sword]
    if hero:get_state() == "sword spin attack" then
      -- The spin attack is twice more powerful.
      damage_factor = damage_factor * 2
    elseif hero:get_state() == "running" then
      -- Hitting an enemy while running is twice more powerful.
      damage_factor = damage_factor * 2
    end

    local reaction = self:get_attack_consequence_sprite(enemy_sprite, "sword")
    self:remove_life(reaction * damage_factor)
  end
end

-- Initializes map entity related behaviors.
local function initialize_entities()

  initialize_destructibles()
  initialize_enemies()
end

-- Performs global initializations specific to this quest.
function quest_manager:initialize_quest()

  initialize_map()
  initialize_entities()
end

return quest_manager

