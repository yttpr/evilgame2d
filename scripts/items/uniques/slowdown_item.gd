class_name SlowdownItem

extends BasicItem

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if Manager.is_paused or handler.Player.is_dead:
		return
	if handler.mouse_down:
		Engine.time_scale = 0.35
	else:
		Engine.time_scale = 1.0
