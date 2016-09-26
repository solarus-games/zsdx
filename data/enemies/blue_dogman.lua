local enemy = ...

-- Blue Dogman

require("enemies/generic_towards_hero")(enemy)
enemy:set_properties({
  sprite = "enemies/blue_dogman",
  life = 6,
  damage = 4,
  normal_speed = 48,
  faster_speed = 48
})

