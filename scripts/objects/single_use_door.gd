class_name SingleUseDoorInteractible

extends DoorInteractible

@export var key : String
@export var image : Sprite2D
@export var unlockedicon : Texture2D
@export var lockedicon : Texture2D

func _ready() -> void:
	super._ready()
	locked = Manager._check_run_bool(key)
	if locked:
		image.texture = lockedicon
	else:
		image.texture = unlockedicon

func _run() -> void:
	super._run()
	Manager._set_run_bool(key, true)
