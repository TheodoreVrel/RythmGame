extends CanvasLayer


@onready var combo_label : Label = $Label

func update_combo(combo: int):
	combo_label.text = "Combo: " + str(combo)

func update_won():
	combo_label.text = "Enemy defeated!"
