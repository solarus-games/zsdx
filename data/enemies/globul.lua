local enemy = ...

-- Globul.

require("enemies/generic_towards_hero")(enemy)
enemy:set_properties({
  sprite = "enemies/globul",
  life = 4,
  damage = 2
})

