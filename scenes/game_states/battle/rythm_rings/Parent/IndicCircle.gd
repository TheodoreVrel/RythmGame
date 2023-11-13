extends Sprite2D

@export var indic_circles : Array[Texture2D]


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = indic_circles.pick_random()
	scale = Vector2(0.4, 0.4)
	

