class_name BothTypesProjectile

extends MovingProjectile

func _shoot(direction : Vector2, origin : Vector2) -> void:
	img.rotation = direction.angle()
	if self.type == "NULL":
		var copy : BothTypesProjectile = self.duplicate()
		copy.visible = true
		copy._set_basic_data(dmg, "Cos", knockback_mod)
		copy.source += "_Cos"
		copy.img.flip_v = true
		self.get_parent().add_child(copy)
		copy._shoot(direction, origin + Vector2.from_angle(direction.angle() - (PI/2)) * 3)
		self._set_basic_data(dmg, "Sin", knockback_mod)
		self.source += "_Sin"
		super._shoot(direction, origin + Vector2.from_angle(direction.angle() + (PI/2)) * 3)
	else:
		super._shoot(direction, origin)
