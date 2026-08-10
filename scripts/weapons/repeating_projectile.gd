class_name RepeatingProjectile

extends MovingProjectile

@export var repeats : int
@export var interval : float
@export var is_player : bool

@export var original = true

func _shoot(direction : Vector2, origin : Vector2) -> void:
	if !original:
		super._shoot(direction, origin)
		return
	#self.collider.collider.disabled = true
	self.visible = false
	for i in repeats:
		var copy : RepeatingProjectile = self.duplicate()
		copy.visible = true
		copy.original = false
		self.get_parent().add_child(copy)
		if is_player:
			var mouse = to_global(get_local_mouse_position())
			var dir = Manager.Player.weapon_handler.pointer.global_position.direction_to(mouse)
			var loc = Manager.Player.weapon_handler.pointer.global_position
			if Manager._check_in_wall(loc - Manager.Player.weapon_handler._get_offset_vector()):
				loc = Manager.Player.weapon_handler.weapon.global_position
			copy._shoot(dir, loc)
		else:
			copy._shoot(direction, origin)
		
		await get_tree().create_timer(interval).timeout
	self.queue_free()


func _process(delta: float) -> void:
	if original:
		return
	super._process(delta)
