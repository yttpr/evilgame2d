class_name MultiHitscanProjectile

extends HitscanProjectile

@export var shot_amount : int
@export var shot_variance : float

func _shoot(direction : Vector2, origin : Vector2) -> void:
	Manager._play_oneshot(origin, shot_sound, audio_mod, pitch_mod)
	lastPos = origin
	
	var angle = direction.angle()
	
	for i in shot_amount:
		_make_shot(Vector2.from_angle(angle + randf_range(shot_variance * -1, shot_variance)), origin)

func _make_shot(direction : Vector2, origin : Vector2) -> void:
	_next_line(length, origin - _offset(), origin - _offset() + direction * length, [])

func _get_bouncer_collision_mask() -> int:
	return super._get_bouncer_collision_mask()

func _make_collider(orig : Vector2, target : Vector2) -> DamageCollider:
	var ret = super._make_collider(orig, target)
	ret.exclude_extra = true
	return ret
