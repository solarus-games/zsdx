local enemy = ...

-- Red pig soldier.

require("enemies/generic_soldier")(enemy)
enemy:set_properties({
  main_sprite = "enemies/red_pig_soldier",
  sword_sprite = "enemies/red_pig_soldier_sword",
  life = 12,
  damage = 24,
  play_hero_seen_sound = true,
  hurt_style = "monster"
})

