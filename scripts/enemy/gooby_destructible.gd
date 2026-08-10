class_name GoobyDestructible

extends BaseDestructible

@export var gooby : Sprite2D

@export var inwater : bool
@export var water : Sprite2D

func _ready() -> void:
	super._ready()
	gooby.modulate = Color.from_hsv(randf_range(0.0, 1.0), 1.0, 1.0)
	gooby.flip_h = randf_range(0.0, 1.0) < 0.5
	water.visible = inwater
	if inwater:
		gooby.frame = 1


func _clean() -> void:
	super._clean()
	water.visible = false
