class_name FrameSetDestructible

extends BaseDestructible

@export var frame_id : int

func _ready() -> void:
	super._ready()
	image.frame = frame_id
