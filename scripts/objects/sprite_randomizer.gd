class_name SpriteRandomizer

extends Sprite2D
@export var outline : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.frame = randi_range(0, self.hframes - 1)
	if outline:
		outline.frame = self.frame
	self.rotation = randf_range(0.0, 2*PI)
