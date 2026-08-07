class_name FadoutProjectile

extends MovingProjectile

@export var collider_time : float

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	collider._set_duration(true, collider_time)
	var moving = get_tree().create_tween()
	moving.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0.0), lifetime)
