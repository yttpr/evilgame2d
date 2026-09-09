extends BaseDestructible

@export var bullet : PackedScene
@export var source_name : String
@export var shoot_from : Node2D
@export var amount : int
@export var sub_damage : int = 1

func _clean() -> void:
	super._clean()
	_explode()

@export var dmg_amt : int
@export var damage_type : String
@export var knockback : float

@export var explosion_sound : AudioStream
@export var volume_mod : float

func _explode() -> void:
	if explosion_sound:
		Manager._play_oneshot(self.global_position, explosion_sound, volume_mod)
	for i in amount:
		_shoot(Vector2.from_angle(((2*PI) / amount) * i))

@export var source_mod : String = "abcdefghijklmnopqrstuvwxyz"
var source_index : int = 0
func _shoot(dir : Vector2, pierce_amt : int = 0) -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().add_child(proj)
	proj.source = source_name
	proj.source += "_" + source_mod[source_index]
	source_index += 1
	if source_index >= source_mod.length():
		source_index = 0
	proj.visible = true
	proj._set_basic_data(sub_damage, damage_type, knockback)
	proj._set_collision(proj.source, Manager.collision_walls, Manager.collision_all)
	proj.pierce_amt = pierce_amt
	proj.y_change = shoot_from.position.y
	proj._shoot(dir, shoot_from.global_position)
