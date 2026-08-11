class_name MousePathfinding

extends GeneralPathfinding

@export var near_tick_time : int = 10

func _process(delta: float) -> void:
	if Movable.is_dead:
		Weapon.is_agro = false
		Weapon.process_mode = Node.PROCESS_MODE_DISABLED
		Movable.velocity = Vector2.ZERO
		return
	
	tick -= 1
	if tick < 0:
		tick = process_tick
		var dest = to_global(get_local_mouse_position())
		_set_target(dest)
		if Movable.global_position.distance_to(dest) < 1000:
			tick = near_tick_time
