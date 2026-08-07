class_name AntiProjectile

extends MovingProjectile

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction * -1, origin)
