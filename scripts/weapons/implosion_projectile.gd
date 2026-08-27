class_name ImplosionProjectile

extends ExplodingProjectile

##if false, tracks mouse
@export var on_player : bool = true

@export var out_distance : float


func _shoot(direction : Vector2, origin : Vector2) -> void:
	self.global_position = origin - _offset()
	img.position = _offset()
	
	#_explode()
	
	_cleanup()

@export var offset_name : String

func _explode() -> void:
	#print("hi")
	if explosion_sound:
		Manager._play_oneshot(self.global_position, explosion_sound, volume_mod)
	
	if on_player:
		self.global_position = Manager.Player.global_position
	else:
		self.global_position = to_global(get_local_mouse_position())
	
	var orig : String = source_name
	for i in amount:
		source_name = orig + "_" + offset_name[i]
		_shoot_buddy(Vector2.from_angle(((2*PI) / amount) * i))

func _shoot_buddy(dir : Vector2) -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().call_deferred("add_child", proj)
	proj.death_quote.assign(death_quote)
	if randomize_pitch:
		proj.pitch_mod = randf_range(-15, 5)
	proj.visible = true
	proj._set_basic_data(dmg, type, knockback_mod)
	if collision_only_player:
		proj._set_collision(source_name, Manager.collision_walls, Manager.collision_onlyPlayer)
	elif collision_only_enemy:
		proj._set_collision(source_name, Manager.collision_walls, Manager.collision_onlyEnemies)
	elif collision_only_walls:
		proj._set_collision(source_name, Manager.collision_walls, Manager.collision_walls)
	else:
		proj._set_collision(source_name, Manager.collision_walls, Manager.collision_all)
	proj.y_change = shoot_from.position.y
	if proj is MovingProjectile:
		var mov : MovingProjectile = proj
		mov.img.rotation = (dir * -1).angle()
	proj.call_deferred("_shoot", dir * -1, shoot_from.global_position + dir * out_distance)
