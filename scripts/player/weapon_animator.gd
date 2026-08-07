class_name WeaponAnimator

extends Sprite2D

@export var player : CharacterAnimator

@export var pointer_length : float
@export var pointer : Node2D

@export var secondary : Node2D

func _set_pointer() -> void:
	pointer.position.x = pointer_length
func _ready() -> void:
	_set_pointer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Manager.is_paused:
		return
	var mouse = to_global(get_local_mouse_position())
	var dir = self.global_position.direction_to(mouse)
	self.global_rotation = dir.angle()
	
	self.show_behind_parent = !player.down
	
	if dir.x < 0:
		self.flip_v = true
	elif dir.x > 0:
		self.flip_v = false
	
	if secondary:
		secondary.show_behind_parent = player.down
		if player.flip_h:
			secondary.scale.x = -1.0
		else:
			secondary.scale.x = 1.0
