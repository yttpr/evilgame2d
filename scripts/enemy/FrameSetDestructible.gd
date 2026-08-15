class_name FrameSetDestructible

extends BaseDestructible

@export var frame_id : int
@export var flip : bool

func _ready() -> void:
	super._ready()
	image.frame = frame_id
	if flip:
		image.flip_h = true
