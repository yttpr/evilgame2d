class_name HomingPathfinding

extends GeneralPathfinding

@export var always : bool
var skip_base_lock_on : bool

@export var vision_range : float = 500

@export var limit_range : float = 100
@export var max_range : float = 3000
var slow_down : bool

@export var can_target_delay : float = 0.5
var check_tick : float

@export var bored_time : float = 10
@export var bored_chance : float = 0.8
var bored_tick : float

@export var wander_time : float = 2
@export var wander_chance : float = 0.3
@export var wander_speed : float = 75
var wander_tick : float

var wandering : bool

func _ready() -> void:
	super._ready()
	check_tick = can_target_delay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#wander
	if _at_target():
		wander_tick += delta
		if wander_tick >= wander_time:
			if randf_range(0.0, 1.0) < wander_chance:
				did_see = false
				_set_moving(true)
				_wander()
			else:
				wander_tick = 0
	else:
		wander_tick = 0
	
	if Follow_Target and _can_see(Follow_Target):
		bored_tick = 0
		wandering = false
	else:
		bored_tick += delta
		if bored_tick >= bored_time:
			#print("bored time, ", Movable.name)
			if randf_range(0.0, 1.0) < bored_chance:
				#print("win")
				Follow_Target = null
				did_see = false
				_set_moving(true)
				_wander()
			bored_tick = 0
	
	if Follow_Target:
		super._process(delta)
	if !Follow_Target and !skip_base_lock_on and (_can_see(Manager.Player) or always):
		_set_follow(Manager.Player, !always)
	
	if !Follow_Target:
		return
	
	#deagro
	if !_can_see(Follow_Target):
		if Weapon.break_aim_if_lost and Weapon.aiming_tick > 0:
			#print("end by cant see")
			Weapon.is_agro = false
	if Movable.global_position.distance_to(Follow_Target.global_position) > max_range:
		if Weapon.break_aim_if_lost and Weapon.aiming_tick > 0:
			#print("end by out of range")
			Weapon.is_agro = false
	
	if !Weapon.is_agro:
		slow_down = false
		if _can_target(Follow_Target) and Movable.global_position.distance_to(Follow_Target.global_position) <= max_range:
			check_tick -= delta
			if check_tick <= 0:
				Weapon._set_agro(Follow_Target)
				if !Weapon.move_during_charge:
					_set_moving(false)
		else:
			_set_moving(true)
			slow_down = false
			check_tick = can_target_delay
	else:
		check_tick = can_target_delay
		if _can_target(Follow_Target) and Movable.global_position.distance_to(Follow_Target.global_position) <= limit_range:
			slow_down = true
			nav_agent.max_speed = _get_speed()
		else:
			slow_down = false
			nav_agent.max_speed = _get_speed()


func _get_speed() -> float:
	if slow_down:
		return 2
	if wandering:
		return wander_speed
	return super._get_speed()


func _can_see(target : Node2D) -> bool:
	var ret = super._can_see(target)
	if !ret or self.global_position.distance_to(target.global_position) > vision_range:
		return false
	return ret

func _can_target(targetNode : Node2D) -> bool:
	var ret = super._can_target(targetNode)
	if !ret or self.global_position.distance_to(targetNode.global_position) > vision_range:
		return false
	return ret

func _wander() -> void:
	super._wander()
	if Weapon:
		Weapon.is_agro = false
	wandering = true
