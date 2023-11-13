extends Node2D

var crescendo_rythm_ring_scene : PackedScene = preload("res://scenes/game_states/battle/rythm_rings/Crescendo/crescendo_rythm_indicator.tscn")
var stretto_rythm_ring_scene : PackedScene = preload("res://scenes/game_states/battle/rythm_rings/Stretto/stretto_rythm_indicator.tscn")
var tranquillo_rythm_ring_scene : PackedScene = preload("res://scenes/game_states/battle/rythm_rings/Tranquillo/tranquillo.tscn")

var enemy_scene : PackedScene = preload("res://scenes/game_states/battle/enemies/enemy.tscn")

@onready var rythm_rings_container = $RythmRings
@onready var enemies_container = $Enemies

var enemy_hp : int = 1000
var player_hp: int = 80
var player_shield: int = 0
var combat_started : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy = enemy_scene.instantiate()
	enemies_container.add_child(enemy)
	

	$Player/AnimationPlayer.play("move_player_left")
	
func combat_start():
	combat_started = true
	
func _on_ui_button_pressed(button_number):
	if combat_started:
		$UI/ComboUI.visible = true
		match button_number:
			1:
				create_rythm_ring(crescendo_rythm_ring_scene)
			2:
				create_rythm_ring(stretto_rythm_ring_scene)
			3:
				create_rythm_ring(tranquillo_rythm_ring_scene)
			4:
				pass
			_:
				pass

func create_rythm_ring(init_rythm_ring: PackedScene):
	if rythm_rings_container.get_child_count() == 0:
		var rythm_ring = init_rythm_ring.instantiate()
		rythm_rings_container.add_child(rythm_ring)
		rythm_ring.connect("lost", on_lost_rythm_game)
		rythm_ring.connect("hp_change", on_hp_change)
		rythm_ring.connect("combo", on_combo_change)

		
		
		disable_buttons()

func disable_buttons():
	disable_button($UI/OptionsPanel/BoxContainer/HBoxContainer/Button1)
	disable_button($UI/OptionsPanel/BoxContainer/HBoxContainer/Button2)
	disable_button($UI/OptionsPanel/BoxContainer/HBoxContainer2/Button3)
	disable_button($UI/OptionsPanel/BoxContainer/HBoxContainer2/Button4)

func enable_buttons():
	enable_button($UI/OptionsPanel/BoxContainer/HBoxContainer/Button1)
	enable_button($UI/OptionsPanel/BoxContainer/HBoxContainer/Button2)
	enable_button($UI/OptionsPanel/BoxContainer/HBoxContainer2/Button3)
	enable_button($UI/OptionsPanel/BoxContainer/HBoxContainer2/Button4)

func disable_button(button: BaseButton):
	button.disabled = true

func enable_button(button: BaseButton):
	button.disabled = false

func on_lost_rythm_game():
	enable_buttons()
	$UI/ComboUI.visible = false

func on_hp_change(hp_mod: int, targets_enemy: bool):
	if targets_enemy:
		enemy_hp -= hp_mod
		if enemy_hp <= 0:
			enemy_hp = 0
			won_fight()
		$UI/EnemyUI.update_enemy_hp(enemy_hp)
		$Enemies.get_child(0).get_child(0).material.set_shader_parameter("progress", 0.4)
		$Timers/EnemyShaderBlinkTimer.start()
	else:
		player_shield -= hp_mod
#		if player_hp <= 0:
#			player_hp = 0
		if player_shield <= 0:
			player_shield = 0
		$UI/PlayerUI.update_player_hp(player_hp, player_shield)
		print(player_hp, " | ", player_shield)

func on_combo_change(value: int):
	$UI/ComboUI.update_combo(value)

func won_fight():
	$Timers/WonFightDelay.start()
	$UI/EnemyUI.queue_free()
	$RythmRings.get_child(0).queue_free()
	$UI/ComboUI.update_won()
	$UI/ComboUI.visible = true


func _on_enemy_shader_blink_timer_timeout():
	var progress: float = (1000-float(enemy_hp))/1000
	if $Enemies.get_child_count() != 0:
		$Enemies.get_child(0).get_child(0).material.set_shader_parameter("progress", progress)


func _on_won_fight_delay_timeout():
	if $Enemies.get_child_count() != 0:
		$Enemies.get_child(0).queue_free()

