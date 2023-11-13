extends CanvasLayer


signal button_pressed(button_number: int)

@onready var button1 : BaseButton = $BoxContainer/HBoxContainer/Button1
@onready var button2 : BaseButton = $BoxContainer/HBoxContainer/Button2
@onready var button3 : BaseButton = $BoxContainer/HBoxContainer2/Button3
@onready var button4 : BaseButton = $BoxContainer/HBoxContainer2/Button4

func which_button_pressed(button: BaseButton):
	var button_number : int = button.name.trim_prefix("Button").to_int()
	button_pressed.emit(button_number)

func _on_button_1_pressed():
	which_button_pressed(button1)

func _on_button_2_pressed():
	which_button_pressed(button2)

func _on_button_3_pressed():
	which_button_pressed(button3)
	
func _on_button_4_pressed():
	which_button_pressed(button4)
