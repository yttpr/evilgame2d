class_name RandomDamageHitscan

extends HitscanProjectile

@export var max_damage : int

func _shoot(direction : Vector2, origin : Vector2) -> void:
	self.dmg = randi_range(dmg, max_damage)
	super._shoot(direction, origin)
