class_name HauntingPathfinding

extends HomingPathfinding

@export var look_degrees : float
var seen : bool

func _check_look_at() -> bool:
	var mouse_rot = rad_to_deg(Manager.Player.global_position.direction_to(to_global(get_local_mouse_position())).angle())
	var self_rot = rad_to_deg(Manager.Player.global_position.direction_to(self.global_position).angle())
	return abs(_shortest_rotation(mouse_rot - self_rot)) < look_degrees
func _shortest_rotation(ang : float) -> float:
	var new_ang = fmod(ang, 360)
	if abs(new_ang) > 180:
		if new_ang > 0:
			new_ang -= 360
		else:
			new_ang += 360
	return new_ang

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	seen = _check_look_at()
	Movable.visible = seen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	seen = _check_look_at()
	Movable.visible = seen


func _can_see(target : Node2D) -> bool:
	if !seen:
		return false
	return super._can_see(target)
func _can_target(targetNode : Node2D) -> bool:
	if !seen:
		return false
	return super._can_target(targetNode)
