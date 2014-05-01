local enemy = ...

-- A giant tree boss from Newlink.

local nb_sons_created = 0
local nb_sons_immobilized_needed = 3  -- Number of sons immobilized needed to get him vulnerable.
local vulnerable = false
local initial_life = 8
local son_prefix = enemy:get_name() .. "_son_"

enemy:set_life(initial_life)
enemy:set_damage(4)
enemy:set_optimization_distance(0)
enemy:set_size(16, 16)
enemy:set_origin(8, 13)
enemy:set_pushed_back_when_hurt(false)
enemy:set_invincible()
enemy:set_attack_consequence("sword", "protected")
enemy:set_attack_consequence("arrow", "protected")
enemy:set_attack_consequence("boomerang", "protected")
enemy:set_attack_consequence("hookshot", "protected")
enemy:set_push_hero_on_sword(true)
enemy:set_can_hurt_hero_running(true)
local sprite = enemy:create_sprite("enemies/master_arbror")

function enemy:on_restarted()

  if not vulnerable then
    self:go()
  else
    sprite:set_animation("vulnerable")
  end
end

function enemy:go()

  local m = sol.movement.create("random")
  m:set_speed(32)
  m:set_max_distance(16)
  m:start(self)
  sol.timer.start(self, math.random(2000, 3000), function()
    self:prepare_son()
  end)
end

function enemy:on_hurt(attack)

  local life = self:get_life()
  if life <= 0 then
    sprite:set_ignore_suspend(true)
    self:get_map():get_game():start_dialog("dungeon_3.arbror_killed")
    self:remove_sons()
  else
    if life > 9 then
      nb_sons_immobilized_needed = 3
    elseif life > 7 then
      nb_sons_immobilized_needed = 4
    elseif life > 5 then
      nb_sons_immobilized_needed = 5
    else
      nb_sons_immobilized_needed = 6
    end
  end
end

function enemy:prepare_son()

  if not vulnerable and sprite:get_animation() == "walking" then
    if self:get_nb_sons() < nb_sons_immobilized_needed then
      sprite:set_animation("preparing_son")
      sol.audio.play_sound("hero_pushes")
      sol.timer.start(self, 1000, function() self:create_son() end)
      self:stop_movement()
    end
  end

  sol.timer.start(self, math.random(2000, 5000), function() self:prepare_son() end)
end

function enemy:create_son()

  local x = math.random(-7, 7) * 16

  nb_sons_created = nb_sons_created + 1
  local son_name = son_prefix .. nb_sons_created
  local son = self:create_enemy{
    name = son_name,
    breed = "arbror_root",
    x = x,
    y = 80,
  }
  son.master_arbror = self
  son.speed = 48 + (initial_life - self:get_life()) * 5
  sol.audio.play_sound("stone")
end

-- Returns the number of currently existing sons.
function enemy:get_nb_sons()

  return self:get_map():get_entities_count(son_prefix)
end

-- Returns the number of sons that are currently immobilized.
function enemy:get_nb_sons_immobilized()

  local count = 0
  for son in self:get_map():get_entities(son_prefix) do
    if son.immobilized and not son.disappearing then
      count = count + 1
    end
  end

  return count
end

function sprite:on_animation_finished(animation)

  if animation == "preparing_son" then
    self:set_animation("walking")
    enemy:restart()
  elseif animation == "son_immobilized" then

    if enemy:get_nb_sons_immobilized() >= nb_sons_immobilized_needed
        and not vulnerable then

      vulnerable = true
      enemy:set_attack_consequence("sword", 1)
      enemy:set_attack_consequence("arrow", 2)
      enemy:stop_movement()
      self:set_animation("vulnerable")
      sol.audio.play_sound("boss_hurt")
      sol.timer.stop_all(enemy)
      sol.timer.start(
          enemy:get_map(),  -- To make this timer persist after the enemy gets hurt.
          4000,
          function()
            if enemy:get_life() > 0 then
              enemy:stop_vulnerable()
            end
          end
      )
      enemy:remove_sons()
    else
      self:set_animation("walking")
    end
  end
end

function enemy:son_started_immobilized()

  if enemy:get_nb_sons_immobilized() < nb_sons_immobilized_needed then
    local animation = sprite:get_animation()

    if animation == "preparing_son" then
      self:restart()
    end

    sprite:set_animation("son_immobilized")
  end
end

function enemy:stop_vulnerable()

  vulnerable = false
  self:remove_sons()
  self:set_invincible()
  self:set_attack_consequence("sword", "protected")
  self:set_attack_consequence("arrow", "protected")
  self:set_attack_consequence("hookshot", "protected")
  self:restart()
end

function enemy:remove_sons()

  for son in self:get_map():get_entities(son_prefix) do
    if son:exists() then
      son:disappear()
    end
  end
end

