class_name WanderPathfinding

extends HomingPathfinding


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#wander
	if _at_target():
		wander_tick += delta
		if wander_tick >= wander_time:
			if randf_range(0.0, 1.0) < wander_chance:
				did_see = false
				_wander()
			else:
				wander_tick = 0
	else:
		wander_tick = 0
		bored_tick += delta
		if bored_tick >= bored_time:
			if randf_range(0.0, 1.0) < bored_chance:
				_wander()
			bored_tick = 0
		
		else:
			bored_tick = 0
	
	if !Weapon:
		return
	
	if !_can_see(Manager.Player):
		Weapon.is_agro = false
	if Movable.global_position.distance_to(Manager.Player.global_position) > max_range:
		Weapon.is_agro = false
	# shooting
	if !Weapon.is_agro:
		if _can_target(Manager.Player) and Movable.global_position.distance_to(Manager.Player.global_position) <= max_range:
			check_tick -= delta
			if check_tick <= 0:
				Weapon._set_agro(Manager.Player)
		else:
			check_tick = can_target_delay
	else:
		check_tick = can_target_delay
	
	_set_moving(true)
