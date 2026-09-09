class_name TripleBullet

extends MovingProjectile

@export var original : bool = true
@export var offset : float = 24.0

@export var converge : bool
@export var converge_dist : float

@export var skip_middle : bool
@export var double : bool
@export var source_mod : String = "abcd"

func _shoot(direction : Vector2, origin : Vector2) -> void:
	#img.rotation = direction.angle()
	if original and double:
		var con_point = origin + direction * converge_dist
		var copy : TripleBullet = self.duplicate()
		copy.visible = true
		copy.original = false
		copy.source += "_" + source_mod[2]
		self.get_parent().add_child(copy)
		var dir = direction
		var ori = origin + Vector2.from_angle(direction.angle() - (PI/2)) * offset * 3.0
		if converge:
			dir = ori.direction_to(con_point)
		copy._shoot(dir, ori)
		var dob : TripleBullet = self.duplicate()
		dob.visible = true
		dob.original = false
		dob.source += "_" + source_mod[3]
		self.get_parent().add_child(dob)
		var dir2 = direction
		var ori2 = origin + Vector2.from_angle(direction.angle() + (PI/2)) * offset * 3.0
		if converge:
			dir2 = ori2.direction_to(con_point)
		dob._shoot(dir2, ori2)
	if original:
		var con_point = origin + direction * converge_dist
		var copy : TripleBullet = self.duplicate()
		copy.visible = true
		copy.original = false
		copy.source += "_" + source_mod[0]
		self.get_parent().add_child(copy)
		var dir = direction
		var ori = origin + Vector2.from_angle(direction.angle() - (PI/2)) * offset
		if converge:
			dir = ori.direction_to(con_point)
		copy._shoot(dir, ori)
		var dob : TripleBullet = self.duplicate()
		dob.visible = true
		dob.original = false
		dob.source += "_" + source_mod[1]
		self.get_parent().add_child(dob)
		var dir2 = direction
		var ori2 = origin + Vector2.from_angle(direction.angle() + (PI/2)) * offset
		if converge:
			dir2 = ori2.direction_to(con_point)
		dob._shoot(dir2, ori2)
		if !skip_middle:
			var dir3 = direction
			if converge:
				dir3 = origin.direction_to(con_point)
			super._shoot(dir3, origin)
		else:
			self.queue_free()
			return
	else:
		super._shoot(direction, origin)
	
	if do_wave:
		_go_down()

@export var do_wave : bool
@export var wave_difference : float
@export var wave_time : float
func _go_up() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(img, "position", _offset() - Vector2(0, wave_difference / 2.0), wave_time)
	tween.tween_callback(_go_down)

func _go_down() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(img, "position", _offset() + Vector2(0, wave_difference), wave_time)
	tween.tween_callback(_go_up)

@export var deceleration_rate : float = 1.0
@export var die_if_stop : bool
func _process(delta: float) -> void:
	super._process(delta)
	if deceleration_rate < 1.0:
		body.velocity *= 1.0 - (1.0 - deceleration_rate) * delta * 60
		if body.velocity.length() < 60:
			if die_if_stop:
				self._cleanup()
			else:
				body.velocity = Vector2.ZERO
