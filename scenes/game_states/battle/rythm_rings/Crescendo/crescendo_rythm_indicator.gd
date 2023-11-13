extends RythmIndicatorParent


# Called when the node enters the scene tree for the first time.
func _init():
	initial_indicator_speed = 3600
	health_mod = 5
	clockwise_change = true


func clicked_in_rythm_behavior():
	
	if must_click_check() and !point_hit and Input.is_action_just_pressed("click"):
		rythm_combo += 1
		point_hit_effect()
		if rythm_combo <= 3 :
			indicator_speed = 3660 + 360 * rythm_combo
			health_mod = 10
		if rythm_combo > 3 and rythm_combo <= 6:
			indicator_speed += 540
			health_mod = 10 + 5 * rythm_combo
		if rythm_combo > 6 :
			indicator_speed = (indicator_speed * 1.015) + 60
			health_mod = 10 + 8 * rythm_combo
		

		combo.emit(rythm_combo)
		print("combo : " + str(rythm_combo))
		clicked_in_rythm = true
		if clockwise_change:
			rythm_clockwise = not rythm_clockwise
		
		hp_change.emit(health_mod)
