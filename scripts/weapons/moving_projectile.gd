class_name MovingProjectile

extends BasicProjectile

@export var img : Sprite2D
@export var body : CharacterBody2D

@export var spd : float
@export var radius : float
@export var rot_spd : float

@export var bounces : bool
@export var make_backup_colliders : bool

@export var gravity : float = 0.0
@export var grav_accel : float = 0.0

var collider : DamageCollider

@export var point_in_dir : bool

@export var inverse : bool
#@export var inverse_dist : float
@export var by_mouse_dist : bool

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	if inverse:
		#origin += direction * inverse_dist
		origin = Manager._get_world().to_global(Manager._get_world().get_local_mouse_position())
		direction *= -1
	if by_mouse_dist:
		by_distance = true
		distance = origin.distance_to(Manager._get_world().to_global(Manager._get_world().get_local_mouse_position()))
	
	#super._shoot(direction, origin)
	self.global_position = origin - _offset()
	lastPos = self.global_position
	#img.offset = _offset() / img.scale.x
	
	if point_in_dir:
		img.rotation = direction.angle()
	
	img.position = _offset()
	body.velocity = direction * spd
	
	img.modulate = tracer_color
	
	_make_the_collider()

func _make_the_collider() -> void:
	collider = Manager._create_dmg_collider(dmg, type, source, body.velocity.normalized() * knockback_mod)
	collider.name = "Collider"
	collider._set_parent(self)
	collider._set_collision(damager)
	collider._set_pierce(-1)
	collider._make_collider()
	collider._set_circle(radius)
	collider._set_duration(false, 0)
	collider.death_quote = death_quote
	collider.projectile = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	img.rotate(rot_spd * delta)
	
	var current = self.global_position
	
	if grav_accel > 0:
		if y_change < 0:
			img.position.y = min(0, y_change + gravity * delta)
			y_change = min(0, y_change + gravity * delta)
			gravity += grav_accel * delta
		else:
			self._cleanup()
	
	var dist = body.velocity * delta
	if by_distance:
		if dist.length() > distance:
			dist = dist.normalized() * distance
	var collision = body.move_and_collide(dist)
	if collision:
		if bounces:
			if make_backup_colliders:
				_make_backup_line(current, self.global_position + dist.normalized() * radius)
			body.velocity = body.velocity.bounce(collision.get_normal())
			collider.inertia = body.velocity.normalized() * knockback_mod
		else:
			Manager._play_oneshot(self.global_position, Manager.base_hit_sound, 25.0, 1.5)
			if make_backup_colliders:
				_make_backup_line(current, self.global_position + dist.normalized() * radius)
			self._cleanup()
	
	if delta > 0:
		_draw_tracer(current + _offset(), self.global_position + _offset())
	if make_backup_colliders:
		_make_backup_line(current, self.global_position)
	
	super._process(delta)

func _hit_made(position : Vector2 = Vector2.ZERO) -> bool:
	if pierce_amt == 0:
		collider.collider.set_deferred("disabled", true)
		self._cleanup()
		return true
	pierce_amt -= 1
	return false


func _make_backup_line(orig : Vector2, target : Vector2) -> DamageCollider:
	var col = Manager._create_dmg_collider(dmg, type, source, (orig.direction_to(target)) * knockback_mod)
	col.is_backup = true
	col._set_to_world()
	col.pierce = pierce_amt
	col._set_collision(damager)
	col._set_line(orig, target + orig.direction_to(target) * abs(knockback_mod) / 60.0)
	col.frame_buffer = 2
	col._set_duration(true, 0.03)
	col.death_quote = death_quote
	col.projectile = self
	return col


@export var highlighted_tracer : bool
@export var highlight_tracer_w : float = 1.0
func _draw_tracer(orig : Vector2, pos : Vector2) -> void:
	super._draw_tracer(orig, pos)
	if !highlighted_tracer:
		return
	if tracer_time <= 0:
		return
	
	if pos.y > orig.y:
		var temp = pos
		pos = orig
		orig = temp
	
	var line = Line2D.new()
	Manager._get_world().add_child(line)
	line.global_position = orig - _offset()
	line.global_rotation = 0
	#line.position = self.position
	line.add_point(Vector2.ZERO + _offset())
	line.add_point((pos - _offset()) - line.global_position + _offset())
	line.width = highlight_tracer_w
	line.modulate = tracer_color
	line.material = Manager._tracer_mat()
	line.y_sort_enabled = true
	line.show_behind_parent = true
	line.z_index = 2
	
	# tween
	var tween = get_tree().create_tween()
	if !tracer_fade:
		tween.tween_property(line, "width", 0, tracer_time)
	else:
		var fade = Color(line.modulate)
		fade.a = 0.0
		tween.tween_property(line, "modulate", fade, tracer_time)
	tween.tween_callback(line.queue_free)
	
	#await get_tree().create_timer(tracer_time).timeout
	#line.queue_free()
