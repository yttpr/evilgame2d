class_name RandomDamageHitscan

extends HitscanProjectile

@export var max_damage : int

func _shoot(direction : Vector2, origin : Vector2) -> void:
	self.dmg = randi_range(dmg, max_damage)
	#print(self.dmg)
	self.pitch_mod = 1.5 - (0.12 * self.dmg)
	self.knockback_mod *= float(dmg) / float(max_damage)
	super._shoot(direction, origin)
