class_name FirelineProjectile

extends ExplodingProjectile

@export var spawns : int
@export var dif_mod : float

func _shoot(direction : Vector2, origin : Vector2) -> void:
	if spawns <= 0:
		super._shoot(direction, origin)
	else:
		for i in spawns:
			var copy : FirelineProjectile = self.duplicate()
			copy.spawns = 0
			copy.visible = true
			self.get_parent().add_child(copy)
			copy.gravity += dif_mod * (i + 1)
			copy._shoot(direction, origin)
		super._shoot(direction, origin)
