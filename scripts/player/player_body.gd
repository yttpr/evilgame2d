class_name PlayerBody

extends BaseBody

@export var data : CharacterData

@export var character : String
@export var img : CharacterAnimator
@export var Hitbox : Area2D
@export var camera : PlayerCamera
@export var ui : PlayerStatsDisplay
@export var weapon_handler : WeaponManager
@export var items : ItemHandler

func _set_data(chara : CharacterData) -> void:
	var reset = Manager.current_chara != chara
	if reset:
		Manager.current_hp = ceili(items._check_items("MaxHP", chara.HP, chara, self))
	Manager.current_chara = chara
	data = chara
	character = chara.character
	img.texture = chara.image
	img.always_animate = chara.idle_anims
	if chara.idle_anims:
		img.hframes = 8
	else:
		img.hframes = 6
	img.make_footstep = chara.make_footstep
	HP = ceili(items._check_items("MaxHP", chara.HP, chara, self))
	HP = Manager.current_hp
	healthtype = chara.healthtype
	hit_sound = chara.hurt_sound
	hit_mod = chara.audio_mod
	gibs = chara.gibs
	# health ui
	ui.Health._set_max_health(ceili(items._check_items("MaxHP", chara.HP, chara, self)))
	ui.Health._set_current_health(HP)
	ui.Health._set_health_type(healthtype)
	# weapons
	if reset:
		weapon_handler.weapons.assign(chara.base_weapons)
		weapon_handler.reload_tick = 0
	else:
		weapon_handler.weapons.assign(Manager.current_weapons)
	weapon_handler._setup()

func _ready() -> void:
	is_player = true
	time_to_die = 9999
	if Manager.world:
		global_position = Manager._get_world().entries[Manager.spawn_loc]
	Manager.Player = self
	if Manager.current_chara:
		self.data = Manager.current_chara
	if Manager.current_weapons and Manager.current_weapons.size() > 0:
		self.weapon_handler.weapons.assign(Manager.current_weapons)
	if Manager.current_hp <= 0:
		Manager.current_hp = ceili(items._check_items("MaxHP", data.HP, data, self))
		Manager._reset_points()
		Manager.coins = 0
	
	_set_data(data)
	HP = Manager.current_hp
	super._ready()
	img.visible = true
	ui.Health._set_max_health(ceili(items._check_items("MaxHP", data.HP, data, self)))
	ui.Health._set_current_health(HP)
	ui.Health._set_health_type(healthtype)
	dead_cooldown = 0
	
	await get_tree().process_frame
	if Manager._get_world() and !Manager._get_world().is_spawn:
		Manager._play_oneshot(self.global_position, Manager.door_noise, 15)

var dead_cooldown : float
func _cleanup() -> void:
	dead_cooldown = 1.0
	is_dead = true
	time_to_die = 9999
	img.visible = false
	Manager._open_menu(true)
	Manager.coins = 0
	Manager.current_hp = data.HP
	Manager.current_weapons.assign(data.base_weapons)
	Manager._on_dead()
# movement
func get_input() -> void:
	if is_dead or Manager.is_paused or Manager.lock_input:
		velocity = Vector2.ZERO
		return
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * _get_spd()
func _get_spd() -> float:
	return items._check_items("GetSpd", mov_spd, null, self)


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	get_input()
	super._physics_process(delta)

func _can_hit(amt : int, type : String, source : String) -> bool:
	if is_dead:
		return false
	return items._check_items("CanHit", true, {"amt" : amt, "type" : type, "source" : source}, self)

func _on_hit(amt : int, type : String, source : String) -> void:
	super._on_hit(amt, type, source)
	ui.Health._reduce_health(amt)
	Manager.current_hp = HP
	items._check_items("OnHit", HP, {"amt" : amt, "type" : type, "source" : source}, self)

func _modify_hit(amt : int, type : String, source : String) -> int:
	var temp = super._modify_hit(amt, type, source)
	return items._check_items("ModifyHit", temp, {"amt" : amt, "type" : type, "source" : source}, self)

var death_quotes : Array[String]
func _set_deathquotes(quotes : Array[String]) -> void:
	death_quotes = quotes

var global_i_frame : float
@export var global_i_time : float = 0
func _check_i_frame(source : String) -> bool:
	if source == "Shop" or source == "Item":
		return true
	if global_i_frame <= 0:
		global_i_frame += items._check_items("GlobalIFrames", global_i_time, source, self)
		return super._check_i_frame(source)
	return false

var col_val : float = 1.0
var dec_col : bool = true
func _process(delta : float) -> void:
	if dead_cooldown > 0:
		dead_cooldown -= delta
	super._process(delta)
	#return
	if global_i_frame > 0:
		global_i_frame -= delta
		if col_val >= 0.7:
			dec_col = true
		if col_val <= 0.4:
			dec_col = false
		if dec_col:
			col_val -= delta * 2.0
		else:
			col_val += delta * 2.0
	else:
		col_val = 1.0
		dec_col = true
	img.self_modulate = Color(col_val, col_val, col_val, 1.0)
	weapon_handler.weapon.self_modulate = img.self_modulate
