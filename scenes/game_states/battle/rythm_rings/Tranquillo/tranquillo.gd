extends RythmIndicatorParent

var left_to_right : bool = true

func point_movement(delta):
	if $Path2D/PathFollow2D.progress_ratio >= 0.9:
		left_to_right = false
	if $Path2D/PathFollow2D.progress_ratio <= 0.1:
		left_to_right = true
	
	if left_to_right :
		$Path2D/PathFollow2D.progress_ratio += indicator_speed * delta
		#$Path2D.rotation += indicator_speed * delta
	else:
		$Path2D/PathFollow2D.progress_ratio -= indicator_speed * delta
		#$Path2D.rotation -= indicator_speed * delta
