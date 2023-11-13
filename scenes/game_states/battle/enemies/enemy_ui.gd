extends CanvasLayer

@onready var enemy_hp_label : Label = $Label

func update_enemy_hp(hp_mod: int):
	enemy_hp_label.text = "Worm Health: " + str(hp_mod)
