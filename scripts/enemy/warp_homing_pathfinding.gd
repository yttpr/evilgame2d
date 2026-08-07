class_name WarpHomingPathfinding

extends HomingPathfinding

@export var interval : float
var warp_time : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	warp_time -= delta
	_set_moving(false)
	if warp_time <= 0:
		_set_moving(true)
		warp_time = interval
	
	super._physics_process(delta)
