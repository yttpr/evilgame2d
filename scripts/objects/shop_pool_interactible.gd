class_name ShopPoolWeaponInteractible

extends WeaponInteractible

@export var objectname : String
@export var pool : ShopPoolData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Manager._check_run_bool(objectname):
		self.queue_free()
		return
	
	if !Manager._get_run_arg(objectname):
		_get_weapon()
		Manager._set_run_arg(objectname, weapon.id.to_lower())
	else:
		weapon = _load_weapon(Manager._get_run_arg(objectname))
	
	if !Manager._get_run_arg(objectname + "_coins"):
		Manager._set_run_arg(objectname + "_coins", coin_cost)
	else:
		coin_cost = Manager._get_run_arg(objectname + "_coins")
	if !Manager._get_run_arg(objectname + "_hearts"):
		Manager._set_run_arg(objectname + "_hearts", health_cost)
	else:
		health_cost = Manager._get_run_arg(objectname + "_hearts")
	
	super._ready()

func _get_weapon() -> void:
	var list = []
	for item in pool.base_pool:
		if !Manager._check_run_bool(item.id):
			list.append(item)
	for item in pool.unlocks:
		if Manager._check_save_bool(item.id) and !Manager._check_run_bool(item.id):
			list.append(item)
	if list.size() <= 0:
		list.assign(pool.base_pool)
		for item in pool.unlocks:
			if Manager._check_save_bool(item.id):
				list.append(item)
	weapon = list[randi_range(0, list.size() - 1)]


func _load_weapon(id : String) -> WeaponData:
	return ResourceLoader.load("res://assets/weapons/" + id + ".tres")


func _run() -> void:
	if Manager.current_hp <= health_cost or Manager.coins < coin_cost:
		Manager._play_oneshot(self.global_position, Manager.ui_fail, 20)
		return
	if health_cost > 0:
		Manager.Player._get_hit(health_cost, "NULL", "Shop", Vector2.ZERO)
	if coin_cost > 0:
		Manager.coins -= coin_cost
	
	Manager._play_oneshot(self.global_position, weapon.ready_audio, weapon.audio_mod)
	if Manager.Player.weapon_handler.weapons.size() >= max_hotbar_size:
		var current = Manager.Player.weapon_handler.weapons[Manager.Player.weapon_handler.gun_index]
		Manager.Player.weapon_handler._swap_weapon(weapon, Manager.Player.weapon_handler.gun_index)
		weapon = current
		image.texture = weapon.weapon_img
		health_cost = 0
		coin_cost = 0
		Manager._set_run_arg(self.objectname, weapon.id.to_lower())
		Manager._set_run_arg(objectname + "_coins", coin_cost)
		Manager._set_run_arg(objectname + "_hearts", health_cost)
	else:
		Manager.Player.weapon_handler._add_weapon(weapon)
		Manager._set_run_bool(self.objectname, true)
		self.queue_free()
