extends BaseDestructible

@export var bullet : PackedScene
@export var source_name : String
@export var shoot_from : Node2D
@export var amount : int

func _clean() -> void:
	super._clean()
	_explode()

@export var dmg_amt : int
@export var damage_type : String
@export var knockback : float

func _explode() -> void:
	for i in amount:
		_shoot(Vector2.from_angle(((2*PI) / amount) * i))

func _shoot(dir : Vector2, pierce_amt : int = 0) -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().add_child(proj)
	proj.visible = true
	proj._set_basic_data(dmg_amt, damage_type, knockback)
	proj._set_collision(source_name, Manager.collision_walls, Manager.collision_all)
	proj.pierce_amt = pierce_amt
	proj.y_change = shoot_from.position.y
	proj._shoot(dir, shoot_from.global_position)
