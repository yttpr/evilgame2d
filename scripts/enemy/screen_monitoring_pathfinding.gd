class_name ScreenMonitoringPathfinding

extends HomingPathfinding

var on_screen : bool

@export var lock_on_range : float = 150
@export var screen_min_dist : float = 1000
@export var special : bool

func _ready() -> void:
	super._ready()
	skip_base_lock_on = special

func _process(delta: float) -> void:
	
	if !special:
		super._process(delta)
		if on_screen or Movable.global_position.distance_to(Manager.Player.global_position) < screen_min_dist:
			_set_moving(false)
		else:
			_set_moving(true)
		return
	
	
	if !Follow_Target and Movable.global_position.distance_to(Manager.Player.global_position) <= lock_on_range:
		_set_follow(Manager.Player, !always)
	
	if on_screen:
		if !Follow_Target or (!_can_target(Follow_Target) and (!did_see or _at_target())):
			_set_moving(false)
		else:
			_set_moving(true)
	else:
		_set_moving(true)
	
	super._process(delta)
	
	if on_screen:
		if !Follow_Target or (!_can_target(Follow_Target) and (!did_see or _at_target())):
			_set_moving(false)
		else:
			_set_moving(true)
	else:
		_set_moving(true)
	
	if !Follow_Target:
		Weapon.is_agro = false

func _screen_entered() -> void:
	on_screen = true
func _screen_exited() -> void:
	on_screen = false
