extends Node2D

class_name RythmIndicatorParent

@export var targets_enemies : bool

@export var initial_indicator_speed : float
@export var initial_indicator_speed_multiplier : float
@export var indicator_speed_post3 : float
@export var indicator_speed_post3_multiplier : float
@export var indicator_speed_post6 : float
@export var indicator_speed_post6_multiplier : float
var indicator_speed : float

@export var initial_health_mod : int
@export var health_mod_multiplier : float
@export var health_mod_post3 : int
@export var health_mod_post3_multiplier : float
@export var health_mod_post6 : int
@export var health_mod_post6_multiplier : float
var health_mod : int


var area_1_trigger : bool = false
var area_2_trigger : bool = false
var double_area_trigger : bool = false
var rythm_combo : int = 0
var first_turn : bool = true

var can_click : bool = true
var clicked_in_rythm : bool = true
var point_hit : bool = false
var rythm_missed : int = 0
var rythm_just_missed : bool = false
@export var max_rythm_missed : int = 2

var turning : bool = true

@export var clockwise_change : bool = false
var rythm_clockwise : bool = true
@export var circle_rotate: bool = true

var game_won : bool = false
var game_lost : bool = false

signal hp_change(value: int, enemy: bool)
signal combo(value: int)
signal lost


func _ready():
	indicator_speed = initial_indicator_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): #not _physics_process?
	if !point_hit:
		point_movement(delta)
	
	if !turning:
		var tween = get_tree().create_tween()
		tween.tween_property($".", "indicator_speed", initial_indicator_speed / 10, 0.75 )
#		if rythm_clockwise :
#			$Path2D/PathFollow2D.progress -= indicator_speed /10 * delta
#		else :
#			$Path2D/PathFollow2D.progress += indicator_speed /10 * delta
	if circle_rotate:
		rotation += 0.07 * delta

	if !game_lost:
		must_click_indicator()
		clicked_in_rythm_behavior()
		clicked_out_of_rythm_behavior()

func point_movement(delta):
	if rythm_clockwise :
		#$Path2D/PathFollow2D.progress -= indicator_speed * delta
		$Path2D.rotation += indicator_speed * delta
	else :
		#$Path2D/PathFollow2D.progress += indicator_speed * delta
		$Path2D.rotation -= indicator_speed * delta

func clicking():
	if can_click and Input.is_action_just_pressed("click"):
		can_click = false
		$Timers/DelayBetweenClicks.start()
		return true
	else:
		return false

func _on_delay_between_clicks_timeout():
	print("can click")
	can_click = true


func _on_rythm_detection_area_1_area_entered(_area):
	area_1_trigger = true


func _on_rythm_detection_area_1_area_exited(_area):
	area_1_trigger = false
	missed_rythm_behavior()

func _on_rythm_detection_area_2_area_entered(_area):
	area_2_trigger = true


func _on_rythm_detection_area_2_area_exited(_area):
	area_2_trigger = false
	missed_rythm_behavior()

func must_click_check():
	return (area_1_trigger and area_2_trigger)
	
func must_click_indicator():
	if must_click_check():
		rythm_just_missed = false
		$indic_circle.material.set_shader_parameter("progress", 0.65)
		$indic_circle.rotation += 0.1
	else:
		$indic_circle.material.set_shader_parameter("progress", 0)

func on_hit_effects():
	$indic_circle.scale *= 1.5
	point_hit = true
	$Timers/PointHitEffectTimer.start()

func clicked_in_rythm_behavior():
	if must_click_check() and !point_hit and clicking():
		rythm_combo += 1
		on_hit_effects()
		if rythm_combo <= 3 :
			indicator_speed = initial_indicator_speed + initial_indicator_speed_multiplier * rythm_combo
			health_mod = initial_health_mod + health_mod_multiplier * rythm_combo
		if rythm_combo > 3 and rythm_combo <= 6:
			indicator_speed = indicator_speed_post3 + indicator_speed_post3_multiplier * rythm_combo
			health_mod = health_mod_post3 + health_mod_post3_multiplier * rythm_combo
		if rythm_combo > 6 :
			indicator_speed = indicator_speed_post6 + indicator_speed_post6_multiplier * rythm_combo
			health_mod = health_mod_post6 + health_mod_post6_multiplier * rythm_combo
		

		combo.emit(rythm_combo)
		print("combo : ", (rythm_combo), " | ", health_mod)
		clicked_in_rythm = true
		if clockwise_change:
			rythm_clockwise = not rythm_clockwise
		
		hp_change.emit(health_mod, targets_enemies)



func clicked_out_of_rythm_behavior():
	if !must_click_check() and clicking():
		if rythm_missed >= max_rythm_missed:
			you_lost()
		elif !rythm_just_missed:
			rythm_combo = 0
			combo.emit(rythm_combo)
			$Path2D/PathFollow2D/rythm_point/rythm_point_sprite.material.set_shader_parameter("progress", 1)
			rythm_just_missed = true
			$Timers/OutRythmPenaltyDelay.start()

func missed_rythm_behavior():
	if !first_turn_leniency():
		if (!area_1_trigger and !area_2_trigger):
			if !clicked_in_rythm:
				missed_rythm_penalty()
				
			clicked_in_rythm = false

func missed_rythm_penalty():
	rythm_combo = 0
	combo.emit(rythm_combo)
	if rythm_missed >= max_rythm_missed:
		you_lost()
	else :
		if circle_rotate:
			rotation -= 0.05
		indicator_speed = initial_indicator_speed
	rythm_missed += 1
	print(clicked_in_rythm)

func first_turn_leniency():
	if (!area_1_trigger and !area_2_trigger):
		first_turn = false
	return first_turn


func you_lost():
	print("you lost")
	$Path2D/PathFollow2D/rythm_point/rythm_point_sprite.material.set_shader_parameter("progress", 1)
	game_lost = true
	turning = false
	$Timers/LostTimerDelay.start()


func _on_lost_timer_delay_timeout():
	lost.emit()
	$Path2D/PathFollow2D/rythm_point/rythm_point_sprite.material.set_shader_parameter("progress", 0)
	queue_free()

#func on_lost(node: Node2D):
#	if node.has_method("enable_buttons"):
#		node.enable_buttons()

func _on_point_hit_effect_timer_timeout():
	$indic_circle.scale = Vector2(0.4, 0.4) #original value
	point_hit = false


func _on_out_of_rythm_penalty_delay_timeout():
	rythm_missed += 1
	rythm_just_missed = false
	$Path2D/PathFollow2D/rythm_point/rythm_point_sprite.material.set_shader_parameter("progress", 0)
	print("color back and rythms missed = ", rythm_missed)



