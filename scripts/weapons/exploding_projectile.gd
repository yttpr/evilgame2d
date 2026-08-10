class_name ExplodingProjectile

extends MovingProjectile

@export var bullet : PackedScene
@export var source_name : String
@export var shoot_from : Node2D
@export var amount : int

func _cleanup() -> void:
	_explode()
	super._cleanup()

func _explode() -> void:
	for i in amount:
		_shoot_buddy(Vector2.from_angle(((2*PI) / amount) * i))

@export var collision_only_player : bool
func _shoot_buddy(dir : Vector2) -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().add_child(proj)
	proj.visible = true
	proj._set_basic_data(dmg, type, knockback_mod)
	if collision_only_player:
		proj._set_collision(source_name, Manager.collision_walls, Manager.collision_forEnemy)
	else:
		proj._set_collision(source_name, Manager.collision_walls, Manager.collision_all)
	proj.y_change = shoot_from.position.y
	proj._shoot(dir, shoot_from.global_position)
