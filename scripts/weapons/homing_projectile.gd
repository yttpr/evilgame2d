class_name HomingProjectile

extends PointedProjectile

@export var detection : Area2D
@export var turn_spd : float
@export var img_rotate_spd : float
@export var track_mouse_instead : bool

var in_range : Array[Node2D]

var nearest : Node2D

func _ready() -> void:
	in_range = []

func _process(delta : float) -> void:
	super._process(delta)
	if img_rotate_spd != 0.0:
		img.rotate(img_rotate_spd * delta)
	
	if nearest != null or track_mouse_instead:
		var destination = to_global(get_local_mouse_position())
		if !track_mouse_instead:
			destination = nearest.global_position
		var aim = body.global_position.direction_to(destination).angle()
		aim = _normal_angle(aim)
		var angle = _normal_angle(body.velocity.angle())
		var result = deg_to_rad(_shortest_rotation(rad_to_deg(aim - angle)))
		if result > 0:
			angle += min(turn_spd * delta, result)
		if result < 0:
			angle -= max(turn_spd * delta, result)
		if img_rotate_spd == 0.0:
			img.rotation = angle
		body.velocity = Vector2.from_angle(angle) * body.velocity.length()

func _get_angle(current : float, target : float) -> float:
	var below = current - (target - 2*PI)
	var neutral = current - target
	var above = current - (target + 2*PI)
	
	if abs(below) < abs(neutral):
		return target - 2*PI
	if abs(above) < abs(neutral):
		return target + 2*PI
	return target

func _normal_angle(angle : float) -> float:
	if angle > 2*PI:
		return _normal_angle(angle - 2*PI)
	if angle < 0:
		return _normal_angle(angle + 2*PI)
	return angle

func _shortest_rotation(ang : float) -> float:
	var new_ang = fmod(ang, 360)
	if abs(new_ang) > 180:
		if new_ang > 0:
			new_ang -= 360
		else:
			new_ang += 360
	return new_ang

func _body_entered(node : Node2D) -> void:
	in_range.append(node)
	_set_nearest()
func _body_exited(node : Node2D) -> void:
	in_range.erase(node)
	_set_nearest()

func _set_nearest() -> void:
	if in_range.size() <= 0:
		nearest = null
		return
	var dist = INF
	for node in in_range:
		var len = self.global_position.distance_to(node.global_position)
		if len < dist:
			dist = len
			nearest = node
