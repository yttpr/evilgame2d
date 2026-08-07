class_name SuperhotPathfinding

extends HomingPathfinding

func _process(delta: float) -> void:
	super._process(delta)
	
	if Manager.Player.velocity.length() <= 0:
		_set_moving(false)
		Weapon.is_agro = false
	else:
		_set_moving(true)
