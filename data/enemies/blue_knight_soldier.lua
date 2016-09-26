local enemy = ...

-- Blue knight soldier.

require("enemies/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/blue_knight_soldier",
  sword_sprite = "enemies/blue_knight_soldier_sword",
  life = 3,
  damage = 2,
  play_hero_seen_sound = true
})

