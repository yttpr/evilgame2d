class_name FlipHealthBody

extends BaseBody

@export var cooldown_time : float
var cooldown_tick : float = 0.0

func _on_hit(amt : int, type : String, source : String) -> void:
	if cooldown_tick > 0:
		return
	cooldown_tick = cooldown_time
	if healthtype == "Sin":
		healthtype = "Cos"
	else:
		healthtype = "Sin"
	_update_marker()

func _process(delta : float) -> void:
	super._process(delta)
	if cooldown_tick > 0:
		cooldown_tick -= delta
