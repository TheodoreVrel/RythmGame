extends Sprite2D

@export var path_circles : Array[Texture2D]


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = path_circles.pick_random()
	scale = Vector2(1, 1)
