class_name PointedProjectile

extends MovingProjectile

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	img.rotation = direction.angle()
