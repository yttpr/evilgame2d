class_name RandomizationProjectile

extends BasicProjectile

@export var sources : Array[WeaponData]

func _shoot(direction : Vector2, origin : Vector2) -> void:
	var weapon = sources[randi_range(0, sources.size() - 1)]
	var proj : BasicProjectile = weapon.bullet.instantiate()
	Manager._get_world().add_child(proj)
	proj.death_quote = self.death_quote
	proj._set_basic_data(weapon.damage_amt, weapon.damage_type, weapon.knockback)
	proj._set_collision(source, bouncer, damager)
	proj.pierce_amt = weapon.pierce_amt
	proj.y_change = y_change
	proj._shoot(direction, origin)
	self.queue_free()
