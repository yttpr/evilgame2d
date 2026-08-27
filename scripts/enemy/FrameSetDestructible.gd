class_name FrameSetDestructible

extends BaseDestructible

@export var frame_id : int
@export var flip : bool
##in degrees
@export var img_rot : float = 0.0

func _ready() -> void:
	super._ready()
	image.frame = frame_id
	if flip:
		image.flip_h = true
	image.rotation = deg_to_rad(img_rot)
