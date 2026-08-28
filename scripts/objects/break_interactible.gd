class_name BreakInteractible


extends BaseInteractible

@export var object : Node2D
@export var sound : AudioStream
@export var vol : float

func _run() -> void:
	object.visible = false
	Manager._play_oneshot(self.global_position, sound, vol)
	can_interact = false
