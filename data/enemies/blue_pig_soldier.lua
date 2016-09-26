local enemy = ...

-- Blue pig soldier.

require("enemies/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/blue_pig_soldier",
  sword_sprite = "enemies/blue_pig_soldier_sword",
  life = 8,
  damage = 16,
  play_hero_seen_sound = true,
  hurt_style = "monster"
})

