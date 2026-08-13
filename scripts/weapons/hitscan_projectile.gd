class_name HitscanProjectile

extends BasicProjectile

@export var collider_duration : float

@export var bounces : bool
@export var length : float

@export var stop_enemies : bool

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	_next_line(length, origin - _offset(), origin - _offset() + direction * length, [])

func _get_bouncer_collision_mask() -> int:
	if stop_enemies:
		return Manager.collision_pierceless.collision_mask
	return bouncer.collision_mask

func _next_line(length : float, origin: Vector2, target_point : Vector2, exclude : Array[RID]) -> Vector2:
	
	#var tarjet = _set_vector_magnitude(target_point, origin, length)
	#make query
	var query = PhysicsRayQueryParameters2D.create(origin, target_point, _get_bouncer_collision_mask(), exclude)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		
		#result.position -= _get_offset_vector()
		
		_draw_tracer(origin + _offset(), result.position + _offset())
		_make_collider(origin, result.position)
		
		# get bounce vector
		var orig = result.position - origin
		length -= orig.length()
		if length <= 0 or result.normal == Vector2.ZERO or !bounces:
			return result.position
		
		var aim = orig.bounce(result.normal)
		var finish = _set_vector_magnitude(aim, Vector2.ZERO, length)
		
		return _next_line(length, result.position + finish.normalized(), result.position + finish, [])
	
	_draw_tracer(origin + _offset(), target_point + _offset())
	_make_collider(origin, target_point)
	
	return target_point

func _set_vector_magnitude(vector : Vector2, origin : Vector2, length : float) -> Vector2:
	return origin.direction_to(vector) * length

func _make_collider(orig : Vector2, target : Vector2) -> DamageCollider:
	var col = Manager._create_dmg_collider(dmg, type, source, (orig.direction_to(target)) * knockback_mod)
	col._set_to_world()
	col.pierce = pierce_amt
	col._set_line(orig, target + orig.direction_to(target) * 32)
	col.frame_buffer = 5
	col._set_duration(true, collider_duration)
	col._set_collision(damager)
	col.death_quote = death_quote
	return col
