class_name LookOnlyAnimator

extends CharacterAnimator

@export var look_towards_player : bool
@export var auto_look : bool = true
@export var look_dir : Vector2

@export var mind : GeneralPathfinding
@export var weapon : EnemyWeapon

@export var update_time : float = 0.15
var tick_time : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tick_time > 0:
		tick_time -= delta
		return
	tick_time = update_time
	
	var weaponactive : bool = true
	if weapon and weapon.is_agro:
		if weapon.stop_looking_after_charge and weapon.aiming_tick <= 0:
			weaponactive = false
	
	if look_towards_player and (auto_look and weaponactive):
		if !mind or mind._can_see(Manager.Player):
			look_dir = body.global_position.direction_to(Manager.Player.global_position)
	
	_process_direction()

func _process_direction() -> void:
	var ang = fmod(rad_to_deg(look_dir.angle()), 360)
	if ang < 0: ang += 360
	
	if abs(ang - 0) < abs(ang - 45) or abs(ang - 360) < abs(ang - 315):
		_set_flip(true)
		self.frame = 2
	elif abs(ang - 45) < abs(ang - 0) and abs(ang - 45) < abs(ang - 90):
		self.frame = 3
		_set_flip(true)
	elif abs(ang - 90) < abs(ang - 45) and abs(ang - 90) < abs(ang - 135):
		self.frame = 4
	elif abs(ang - 135) < abs(ang - 90) and abs(ang - 135) < abs(ang - 180):
		self.frame = 3
		_set_flip(false)
	elif abs(ang - 180) < abs(ang - 135) and abs(ang - 180) < abs(ang - 225):
		self.frame = 2
		_set_flip(false)
	elif abs(ang - 225) < abs(ang - 180) and abs(ang - 225) < abs(ang - 270):
		self.frame = 1
		_set_flip(false)
	elif abs(ang - 270) < abs(ang - 225) and abs(ang - 270) < abs(ang - 315):
		self.frame = 0
	elif abs(ang - 315) < abs(ang - 270) and abs(ang - 315) < abs(ang - 360):
		self.frame = 1
		_set_flip(true)
	else:
		_set_flip(true)
		self.frame = 2

func _set_flip(value : bool) -> void:
	self.flip_h = value
	if value:
		if hitbox:
			hitbox.scale.x = -1.0
	else:
		if hitbox:
			hitbox.scale.x = 1.0
