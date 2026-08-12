class_name ColorRandomizeSprite

extends Sprite2D

@export var random_flip : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate = Color.from_hsv(randf_range(0.0, 1.0), 1.0, 1.0)
	if random_flip:
		self.flip_h = randf_range(0.0, 1.0) < 0.5
	
