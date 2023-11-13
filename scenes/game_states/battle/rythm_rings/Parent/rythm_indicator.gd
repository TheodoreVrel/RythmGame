extends Node2D

class_name RythmIndicatorParent

var initial_indicator_speed: int
var indicator_speed: int
var health_mod: int



var area_1_trigger : bool = false
var area_2_trigger : bool = false
var double_area_trigger : bool = false
var rythm_combo : int = 0
var first_turn : bool = true

var clicked_in_rythm : bool = true
var point_hit : bool = false
var rythm_missed : int = 0
var max_rythm_missed : int = 10

var turning : bool = true

var clockwise_change : bool = false
var rythm_clockwise : bool = true

var game_won : bool = false
var game_lost : bool = false

signal hp_change(value: int)
signal combo(value: int)
signal lost


func _ready():
	indicator_speed = initial_indicator_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): #not _physics_process?
	if !point_hit:
		if rythm_clockwise :
			$Path2D/PathFollow2D.progress -= indicator_speed * delta
			#$Path2D.rotation -= indicator_speed * delta
		else :
			$Path2D/PathFollow2D.progress += indicator_speed * delta
			#$Path2D.rotation += indicator_speed * delta
	
	if !turning:
		var tween = get_tree().create_tween()
		tween.tween_property($".", "indicator_speed", 500, 0.75 )
#		if rythm_clockwise :
#			$Path2D/PathFollow2D.progress -= indicator_speed /10 * delta
#		else :
#			$Path2D/PathFollow2D.progress += indicator_speed /10 * delta
	rotation += 0.07 * delta

	if !game_lost:
		must_click_indicator()
		clicked_in_rythm_behavior()
		clicked_out_of_rythm_behavior()



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
		$indic_circle.material.set_shader_parameter("progress", 0.65)
		$indic_circle.rotation += 3
	else:
		$indic_circle.material.set_shader_parameter("progress", 0)

func point_hit_effect():
	$indic_circle.scale *= 2
	point_hit = true
	$PointHitEffectTimer.start()

func clicked_in_rythm_behavior():
	pass
		
		
func clicked_out_of_rythm_behavior():
	if !must_click_check() and Input.is_action_just_pressed("click"):
		if rythm_missed >= max_rythm_missed:
			you_lost()
		else:
			rythm_combo = 0
			combo.emit(rythm_combo)
			$Path2D/PathFollow2D/rythm_point/rythm_point_sprite.material.set_shader_parameter("progress", 1)
			$MissedRythmPenaltyDelay.start()

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
	game_lost = true
	turning = false
	$Path2D/PathFollow2D/rythm_point/rythm_point_sprite.material.set_shader_parameter("progress", 1)
	$LostTimerDelay.start()


func _on_lost_timer_delay_timeout():
	lost.emit()
	queue_free()

func _on_missed_rythm_penalty_delay_timeout():
	rythm_missed += 1
	$Path2D/PathFollow2D/rythm_point/rythm_point_sprite.material.set_shader_parameter("progress", 0)

#func on_lost(node: Node2D):
#	if node.has_method("enable_buttons"):
#		node.enable_buttons()

func _on_point_hit_effect_timer_timeout():
	$indic_circle.scale = Vector2(0.4, 0.4) #original value
	point_hit = false
