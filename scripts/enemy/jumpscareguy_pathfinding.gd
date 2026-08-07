class_name JumpscareGuyPathfinding

extends HomingPathfinding

@export var look_degrees : float

func _shortest_rotation(ang : float) -> float:
	var new_ang = fmod(ang, 360)
	if abs(new_ang) > 180:
		if new_ang > 0:
			new_ang -= 360
		else:
			new_ang += 360
	return new_ang

func _check_look_at() -> bool:
	var mouse_rot = rad_to_deg(Manager.Player.global_position.direction_to(to_global(get_local_mouse_position())).angle())
	var self_rot = rad_to_deg(Manager.Player.global_position.direction_to(self.global_position).angle())
	return abs(_shortest_rotation(mouse_rot - self_rot)) < look_degrees

var on_screen : bool

func _screen_entered() -> void:
	on_screen = true
func _screen_exited() -> void:
	on_screen = false

@export var scare_time : float
var scare_tick : float
var stop : bool

func _process(delta : float) -> void:
	super._process(delta)
	
	if on_screen and _check_look_at():
		_set_moving(false)
		stop = true
		scare_tick -= delta
		#print("cant move ", scare_tick)
		if scare_tick <= 0:
			_teleport()
			scare_tick = scare_time
	else:
		_set_moving(true)
		#print("movin")
		stop = false
		scare_tick = scare_time
	
	if stop:
		Weapon.is_agro = false

@export var teleport_length : float

func _teleport() -> void:
	var locs = []
	for loc in Manager._get_world().entries:
		if loc.distance_to(Manager.Player.global_position) > teleport_length:
			locs.append(loc)
	if locs.size() > 0:
		Movable.global_position = locs[randi_range(0, locs.size() - 1)]
	else:
		Movable.global_position = Manager._get_world().entries[randi_range(0, Manager._get_world().entries.size() - 1)]
