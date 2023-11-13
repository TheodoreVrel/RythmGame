extends CanvasLayer

@onready var player_hp_label : Label = $Label

func update_player_hp(hp_mod: int, shield_mod: int):
	player_hp_label.text = "Player Health: " + str(hp_mod) 
	if shield_mod > 0:
		player_hp_label.text += " | " + str(shield_mod) + " shields"
