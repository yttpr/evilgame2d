class_name MultiShootProjectile

extends BasicProjectile

@export var bullet : PackedScene
@export var source_name : String
@export var amount : int

@export var is_player : bool
@export var interval : float = 0.1

func _shoot(direction : Vector2, origin : Vector2) -> void:
	self.visible = false
	for i in amount:
		if is_player:
			var mouse = to_global(get_local_mouse_position())
			var dir = Manager.Player.weapon_handler.weapon.global_position.direction_to(mouse)
			var loc = Manager.Player.weapon_handler.pointer.global_position
			if Manager._check_in_wall(loc - Manager.Player.weapon_handler._get_offset_vector()):
				loc = Manager.Player.weapon_handler.weapon.global_position
			_shoot_buddy(dir, loc)
		else:
			_shoot_buddy(direction, origin)
		
		await get_tree().create_timer(interval).timeout
	self.queue_free()

@export var collision_only_player : bool
@export var collision_only_enemy : bool
@export var collision_only_walls : bool
func _shoot_buddy(dir : Vector2, ori : Vector2) -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().call_deferred("add_child", proj)
	proj.death_quote.assign(death_quote)
	proj.source = source_name
	proj.source += "_" + source_mod[source_index]
	source_index += 1
	if source_index >= source_mod.length():
		source_index = 0
	proj.visible = true
	proj._set_basic_data(dmg, type, knockback_mod)
	proj.pierce_amt = pierce_amt
	if collision_only_player:
		proj._set_collision(proj.source, Manager.collision_walls, Manager.collision_forEnemy)
	elif collision_only_enemy:
		proj._set_collision(proj.source, Manager.collision_walls, Manager.collision_onlyEnemies)
	elif collision_only_walls:
		proj._set_collision(proj.source, Manager.collision_walls, Manager.collision_walls)
	else:
		proj._set_collision(proj.source, Manager.collision_walls, Manager.collision_all)
	proj.y_change = y_change
	proj.call_deferred("_shoot", dir, ori)


@export var source_mod : String = "abcdefghijklmnopqrstuvwxyz"
var source_index : int = 0
