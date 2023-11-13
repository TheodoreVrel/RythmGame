extends RythmIndicatorParent


# Called when the node enters the scene tree for the first time.
func _init():
	initial_indicator_speed = 1600
	health_mod = 5
	clockwise_change = false


func clicked_in_rythm_behavior():
	if must_click_check() and Input.is_action_just_pressed("click"):
		rythm_combo += 1
		point_hit_effect()
		if rythm_combo <= 3 :
			indicator_speed = 1660 + 200 * rythm_combo
			health_mod = 3
		if rythm_combo > 3 and rythm_combo <= 4:
			indicator_speed = 3660 + 480 * rythm_combo
			health_mod = 25 + 6 * rythm_combo
		if rythm_combo > 6 :
			indicator_speed = (indicator_speed * 1.15) + 60 * rythm_combo
			health_mod += 15
		
		
		combo.emit(rythm_combo)
		print("combo : " + str(rythm_combo))
		clicked_in_rythm = true
		if clockwise_change:
			rythm_clockwise = not rythm_clockwise
		
		print(max_rythm_missed, " : ", rythm_missed)
		
		hp_change.emit(health_mod)
