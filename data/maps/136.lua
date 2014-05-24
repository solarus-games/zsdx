local map = ...
-- Hidden palace D3

local function change_holes(enable_b)

  for switch in map:get_entities("holes_a_switch") do
    switch:set_activated(enable_b)
  end
  for switch in map:get_entities("holes_b_switch") do
    switch:set_activated(not enable_b)
  end
  map:set_entities_enabled("hole_a", not enable_b)
  map:set_entities_enabled("hole_b", enable_b)
end

function map:on_started(destination)

  change_holes(false)
end

local function holes_a_switch_activated(switch)
  sol.audio.play_sound("secret")
  change_holes(true)
end
for switch in map:get_entities("holes_a_switch") do
  switch.on_activated = holes_a_switch_activated
end

local function holes_b_switch_activated(switch)
  sol.audio.play_sound("secret")
  change_holes(false)
end
for switch in map:get_entities("holes_b_switch") do
  switch.on_activated = holes_b_switch_activated
end

local function save_solid_ground(sensor)
  hero:save_solid_ground()
end

for sensor in map:get_entities("save_solid_ground_sensor") do
  sensor.on_activated = save_solid_ground
end

