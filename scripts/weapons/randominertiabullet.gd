class_name RandomInertiaBullet

extends MovingProjectile

func _make_the_collider() -> void:
	super._make_the_collider()
	self.collider.inertia = Vector2.from_angle(randf_range(0.0, 2*PI)) * randf_range(0.0, knockback_mod)

func _make_backup_line(orig : Vector2, target : Vector2) -> DamageCollider:
	var ret = _make_backup_line(orig, target)
	ret.inertia = Vector2.from_angle(randf_range(0.0, 2*PI)) * randf_range(0.0, knockback_mod)
	return ret
