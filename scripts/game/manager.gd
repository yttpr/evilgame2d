extends Node

var lock_input : bool

var run_bools : Dictionary = {}
var save_bools : Dictionary = {}

var origin_scene : String = "res://assets/levels/spawn.tscn"
var spawn_loc : int

var current_hp : int
var current_gun_index : int = -1
var current_chara : CharacterData
var current_weapons : Array[WeaponData]

var current_zoom : float = -1

var points : int
var Player : PlayerBody
var Camera : PlayerCamera

var coins : int
var wip_coins : int

##deprecated
var noise_vol : float = 1.0
##deprecated
var death_vol_mod : float = 0.0

var world : LevelManager

var base_damage_icon : PackedScene
var base_weak_icon : PackedScene

var base_heal_icon : PackedScene

var base_hit_sound : AudioStream
var reload_loop : AudioStream

var sin_color : Color
var cos_color : Color

var gibs : GibHandler

var bullet_gib : PackedScene

var collision_walls : Area2D
var collision_sight : Area2D
var collision_all : Area2D
var collision_pierceless : Area2D
var collision_forEnemy : Area2D
var collision_onlyPlayer : Area2D
var collision_onlyEnemies : Area2D
var collision_pit : Area2D
var collision_pit_top : Area2D

func _prep_collision_base() -> void:
	collision_walls = Area2D.new()
	collision_walls.set_collision_mask_value(1, false)
	collision_walls.set_collision_mask_value(4, true)
	self.add_child(collision_walls)
	
	collision_sight = Area2D.new()
	collision_sight.set_collision_mask_value(1, false)
	collision_sight.set_collision_mask_value(5, true)
	self.add_child(collision_sight)
	
	collision_all = Area2D.new()
	collision_all.set_collision_mask_value(1, false)
	collision_all.set_collision_mask_value(3, true)
	collision_all.set_collision_mask_value(6, true)
	collision_all.set_collision_mask_value(9, true)
	self.add_child(collision_all)
	
	collision_pierceless = Area2D.new()
	collision_pierceless.set_collision_mask_value(1, false)
	collision_pierceless.set_collision_mask_value(4, true)
	collision_pierceless.set_collision_mask_value(6, true)
	collision_pierceless.set_collision_mask_value(9, true)
	self.add_child(collision_pierceless)
	
	collision_forEnemy = Area2D.new()
	collision_forEnemy.set_collision_mask_value(1, false)
	collision_forEnemy.set_collision_mask_value(3, true)
	collision_forEnemy.set_collision_mask_value(9, true)
	self.add_child(collision_forEnemy)
	
	collision_onlyPlayer = Area2D.new()
	collision_onlyPlayer.set_collision_mask_value(1, false)
	collision_onlyPlayer.set_collision_mask_value(3, true)
	self.add_child(collision_onlyPlayer)
	
	collision_onlyEnemies = Area2D.new()
	collision_onlyEnemies.set_collision_mask_value(1, false)
	collision_onlyEnemies.set_collision_mask_value(6, true)
	collision_onlyEnemies.set_collision_mask_value(9, true)
	self.add_child(collision_onlyEnemies)
	
	collision_pit = Area2D.new()
	collision_pit.set_collision_mask_value(1, false)
	collision_pit.set_collision_mask_value(8, true)
	self.add_child(collision_pit)
	
	collision_pit_top = Area2D.new()
	collision_pit_top.set_collision_mask_value(1, false)
	collision_pit_top.set_collision_mask_value(13, true)
	self.add_child(collision_pit_top)

var base_menu : PackedScene
var menu : MenuHandler
var is_paused : bool
var in_menu : bool

var bright_mat : Material
var coin_sprite : PackedScene
var coin_noise : AudioStream

var door_noise : AudioStream
var door_shake : AudioStream

func _get_world() -> LevelManager:
	if !world:
		print("FUCK")
		return get_tree().root.find_child("LevelManager")
	return world


func _toggle_pause() -> void:
	if is_paused:
		_unpause()
	else:
		_pause()

func _pause() -> void:
	if Player and Player.is_dead:
		return
	is_paused = true
	Engine.time_scale = 0
	
	_open_menu(true)

func _unpause() -> void:
	is_paused = false
	Engine.time_scale = 1
	
	_open_menu(false)

func _open_menu(value : bool) -> void:
	if value:
		if !in_menu:
			if !menu:
				menu = base_menu.instantiate()
				Player.add_child(menu)
				menu.position = Camera.follow_node.position
			menu._enter()
			in_menu = true
	else:
		if in_menu:
			in_menu = false
			if menu:
				menu._exit()

func _input(event):
	if lock_input:
		return
	
	if event is InputEventKey and event.pressed:
		#zoom in
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_BACKSPACE or event.keycode == KEY_P:
			_toggle_pause()

var ui_fail : AudioStream

var water_splash : PackedScene
var splash_noise : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	AudioServer.set_bus_layout(ResourceLoader.load("res://audio/control/noise_bus.tres"))
	
	run_bools = {}
	
	points = 0
	coins = 0
	base_menu = preload("res://assets/ui/menu.tscn")
	
	is_paused = false
	in_menu = false
	
	gibs = GibHandler.new()
	self.add_child(gibs)
	
	base_damage_icon = preload("res://assets/ui/damage_icon.tscn")
	base_weak_icon = preload("res://assets/ui/weak_icon.tscn")
	
	base_hit_sound = ResourceLoader.load("res://audio/noise/ui/damage_generic.wav")
	
	reload_loop = ResourceLoader.load("res://audio/noise/weapon/reload_loop.wav")
	
	sin_color = Color.from_rgba8(255, 0, 0)
	cos_color = Color.from_rgba8(255, 0, 255)
	
	_prep_collision_base()
	
	bullet_gib = preload("res://assets/projectile/BulletGib.tscn")
	
	bright_mat = ResourceLoader.load("res://sprites/objects/shader/unshaded_material.tres")
	
	coin_sprite = preload("res://assets/ui/coin_gib.tscn")
	coin_noise = ResourceLoader.load("res://audio/noise/ui/coin.wav")
	
	Music._set_ambience(true)
	
	door_noise = ResourceLoader.load("res://audio/noise/ui/door_close.ogg")
	door_shake = ResourceLoader.load("res://audio/noise/ui/door_shake.ogg")
	
	ui_fail = ResourceLoader.load("res://audio/noise/ui/ui_fail.ogg")
	
	water_splash = ResourceLoader.load("res://assets/ui/water_splash.tscn")
	splash_noise = ResourceLoader.load("res://audio/noise/ui/water_splash.ogg")
	
	base_heal_icon = preload("res://assets/ui/healing_icon.tscn")
	
	print("all loaded!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player and Player.is_dead:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dying"), AudioServer.get_bus_volume_db(1) - delta * 2)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dying"), 1)

func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		_pause()

func _tracer_mat() -> Material:
	return ResourceLoader.load("res://sprites/objects/shader/unshaded_material.tres")

func _create_dmg_collider(amt : int, type : String, source : String, inertia : Vector2) -> DamageCollider:
	var collider = DamageCollider.new()
	collider._detail(amt, type, source, inertia)
	return collider

func _make_damage_popup(amt : int, loc : Vector2, is_sin : bool) -> void:
	_play_oneshot(loc, base_hit_sound, min(25.0 + amt * 2, 35), max(1.5 - (amt / 10.0), -2))
	
	for i in amt:
		_create_damage(loc, is_sin)

func _create_damage(loc : Vector2, is_sin : bool, is_tan : bool = false, setzero : bool = false) -> void:
	var icon : DamageIcon = base_damage_icon.instantiate()
	if setzero:
		icon.start_height = 15
	_get_world().add_child(icon)
	icon.global_position = loc
	icon._begin()
	if !is_tan:
		icon._set_color(is_sin)
	icon._animate()

func _create_weak(loc : Vector2, is_sin : bool) -> void:
	var icon : DamageIcon = base_weak_icon.instantiate()
	_get_world().add_child(icon)
	icon.global_position = loc
	icon._begin()
	icon._set_color(is_sin)
	icon._animate()

func _make_heal_popup(amt : int, loc : Vector2, is_sin : bool) -> void:
	for i in amt:
		_create_heal(loc, is_sin)

func _create_heal(loc : Vector2, is_sin : bool, is_tan : bool = false, setzero : bool = false) -> void:
	var icon : DamageIcon = base_heal_icon.instantiate()
	if setzero:
		icon.start_height = 15
	_get_world().add_child(icon)
	icon.global_position = loc
	icon._begin()
	if !is_tan:
		icon._set_color(is_sin)
	icon._animate()


func _play_oneshot(loc : Vector2, audio : AudioStream, mod : float = 0.0, pitch : float= 1.0, ignorepause : bool = false) -> BasicAudio:
	if !audio or !world:
		return null
	
	var player = BasicAudio.new()
	player.ignore_pause = ignorepause
	_get_world().add_child(player)
	player.global_position = loc
	player._play_sound(audio, mod, pitch)
	player._set_oneshot(true)
	
	return player

func _make_gibs(loc : Vector2, inertia : Vector2, data : GibData) -> void:
	gibs._make_gibs(loc, inertia, data)


func _make_bullet_gib(loc : Vector2, offset : Vector2, color : Color) -> BulletGibAnimator:
	var gib : BulletGibAnimator = bullet_gib.instantiate()
	_get_world().add_child(gib)
	gib.global_position = loc
	gib._set_offset(offset)
	gib._set_color(color)
	return gib


func _check_in_pit(targetNode : Node2D) -> bool:
	var query = PhysicsRayQueryParameters2D.create(targetNode.global_position, targetNode.global_position + Vector2(0, 500), Manager.collision_pit.collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = Manager._get_world().get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		return result.position == targetNode.global_position or result.normal == Vector2.ZERO
	return false
func _check_in_pit_top(targetNode : Node2D) -> bool:
	var query = PhysicsRayQueryParameters2D.create(targetNode.global_position, targetNode.global_position + Vector2(0, 500), Manager.collision_pit_top.collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = targetNode.get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		return result.position == targetNode.global_position or result.normal == Vector2.ZERO
	return false
func _check_in_wall(pos : Vector2) -> bool:
	var query = PhysicsRayQueryParameters2D.create(pos, pos + Vector2(0, 500), Manager.collision_walls.collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = world.get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		return result.position == pos or result.normal == Vector2.ZERO
	return false

func _reset_points() -> void:
	points = 0
func _add_points(amt : int) -> void:
	points += amt



func _reset_run_data() -> void:
	run_bools = {}
	run_data = {}
func _set_run_bool(arg : String, value : bool) -> void:
	run_bools[arg] = value
func _check_run_bool(arg : String) -> bool:
	if !run_bools:
		return false
	if run_bools.has(arg):
		return run_bools[arg]
	return false

func _update_save_data() -> void:
	if !save_bools:
		save_bools = {}
func _set_save_bool(arg : String, value : bool) -> void:
	save_bools[arg] = value
func _check_save_bool(arg : String) -> bool:
	if !save_bools:
		return false
	if save_bools.has(arg):
		return save_bools[arg]
	return false

var run_data : Dictionary = {}
func _set_run_arg(arg : String, value : Variant) -> void:
	run_data[arg] = value
func _get_run_arg(arg : String) -> Variant:
	if !run_data:
		return null
	if run_data.has(arg):
		return run_data[arg]
	return null

func _make_afterimage(img : Sprite2D, lifetime : float = 0.8) -> void:
	var a : AfterImage = AfterImage.new()
	_get_world().add_child(a)
	a._copy_info(img)
	a._set_lifetime(lifetime)
