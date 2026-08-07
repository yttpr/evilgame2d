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

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	self.global_position = origin - _offset()
	#img.offset = _offset() / img.scale.x
	img.position = _offset()
	body.velocity = direction * spd
	
	img.modulate = tracer_color
	
	collider = Manager._create_dmg_collider(dmg, type, source, body.velocity.normalized() * knockback_mod)
	collider._set_parent(self)
	collider._set_pierce(-1)
	collider._set_circle(radius)
	collider._set_duration(false, 0)
	collider._set_collision(damager)
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
	
	_draw_tracer(current + _offset(), self.global_position + _offset())
	if make_backup_colliders:
		_make_backup_line(current, self.global_position)
	
	super._process(delta)

func _hit_made() -> void:
	if pierce_amt == 0:
		self._cleanup()
	pierce_amt -= 1


func _make_backup_line(orig : Vector2, target : Vector2) -> DamageCollider:
	var col = Manager._create_dmg_collider(dmg, type, source, (orig.direction_to(target)) * knockback_mod)
	col._set_to_world()
	col.pierce = pierce_amt
	col._set_line(orig, target)
	col.frame_buffer = 5
	col._set_duration(true, 0.05)
	col._set_collision(damager)
	col.death_quote = death_quote
	col.projectile = self
	return col
