class_name TripleBullet

extends MovingProjectile

@export var original : bool = true
@export var offset : float = 24.0

func _shoot(direction : Vector2, origin : Vector2) -> void:
	#img.rotation = direction.angle()
	if original:
		var copy : TripleBullet = self.duplicate()
		copy.visible = true
		copy.original = false
		self.get_parent().add_child(copy)
		copy._shoot(direction, origin + Vector2.from_angle(direction.angle() - (PI/2)) * offset)
		var dob : TripleBullet = self.duplicate()
		dob.visible = true
		dob.original = false
		self.get_parent().add_child(dob)
		dob._shoot(direction, origin + Vector2.from_angle(direction.angle() + (PI/2)) * offset)
		super._shoot(direction, origin)
	else:
		super._shoot(direction, origin)
