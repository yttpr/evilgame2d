class_name ItemShopInteractible

extends BaseInteractible

@export var objectname : String
@export var pool : ItemPoolData
var weapon : ItemData

@export var image : Sprite2D

@export var health_cost : int
@export var coin_cost : int

@export var save_only_taken : bool

@export var load_audio : AudioStream
@export var audio_mod : float

@export var options : Array[ItemShopInteractible]
func _close_options() -> void:
	if options:
		for option in options:
			if !option:
				continue
			if option == self:
				continue
			Manager._set_run_bool(option.objectname, true)
			for i in 3:
				Manager._create_damage(option.global_position, false, true, true)
			option.queue_free()

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
	
	image.texture = weapon.image
	label.visible = false

@export var include_starters : bool
@export var separate_pool : bool
func _get_weapon() -> void:
	var ex = ""
	if separate_pool:
		ex = "__"
	var list = []
	for item in pool.base_pool:
		if !Manager._check_run_bool(item.id + ex):
			list.append(item)
	for item in pool.unlocks:
		if Manager._check_save_bool(item.id) and !Manager._check_run_bool(item.id + ex):
			list.append(item)
	if include_starters:
		for item in pool.starters:
			if !Manager._check_run_bool(item.id + ex):
				list.append(item)
	if list.size() <= 0:
		list.assign(pool.base_pool)
		for item in pool.unlocks:
			if Manager._check_save_bool(item.id):
				list.append(item)
	weapon = list[randi_range(0, list.size() - 1)]
	if !save_only_taken:
		Manager._set_run_bool(weapon.id, true)
	if separate_pool:
		Manager._set_run_bool(weapon.id + ex, true)


func _load_weapon(id : String) -> ItemData:
	return ResourceLoader.load("res://assets/items/" + id + ".tres")


func _run() -> void:
	if Manager.current_hp <= health_cost or Manager.coins < coin_cost:
		Manager._play_oneshot(self.global_position, Manager.ui_fail, 20)
		return
	if health_cost > 0:
		Manager.Player._get_hit(health_cost, "NULL", "Shop", Vector2.ZERO)
	if coin_cost > 0:
		Manager._play_oneshot(self.global_position, Manager.purchase_noise, 10)
		Manager.coins -= coin_cost
	
	Manager._play_oneshot(self.global_position, load_audio, audio_mod)
	if weapon.active:
		if Manager.Player.items.active:
			var current = Manager.Player.items.active.data
			Manager.Player.items._set_item(-1, weapon)
			if save_only_taken:
				Manager._set_run_bool(weapon.id, true)
			weapon = current
			image.texture = weapon.image
			health_cost = 0
			coin_cost = 0
			Manager._set_run_arg(self.objectname, weapon.id.to_lower())
			Manager._set_run_arg(objectname + "_coins", coin_cost)
			Manager._set_run_arg(objectname + "_hearts", health_cost)
		else:
			Manager.Player.items._set_item(-1, weapon)
			if save_only_taken:
				Manager._set_run_bool(weapon.id, true)
			Manager._set_run_bool(self.objectname, true)
			self.queue_free()
	else:
		if Manager.Player.items.passives[Manager.current_item_index]:
			var current = Manager.Player.items.passives[Manager.current_item_index].data
			Manager.Player.items._set_item(Manager.current_item_index, weapon)
			if save_only_taken:
				Manager._set_run_bool(weapon.id, true)
			weapon = current
			image.texture = weapon.image
			health_cost = 0
			coin_cost = 0
			Manager._set_run_arg(self.objectname, weapon.id.to_lower())
			Manager._set_run_arg(objectname + "_coins", coin_cost)
			Manager._set_run_arg(objectname + "_hearts", health_cost)
		else:
			Manager.Player.items._set_item(Manager.current_item_index, weapon)
			if save_only_taken:
				Manager._set_run_bool(weapon.id, true)
			Manager._set_run_bool(self.objectname, true)
			self.queue_free()
	
	_close_options()



@export var label : Label

func _on_nearest() -> void:
	if tween:
		tween.kill()
	if health_cost > 0:
		label.visible = true
		label.modulate = Color.WHITE
		label.text = str(health_cost) + " Hearts"
		if coin_cost > 0:
			label.text += "\n" + str(coin_cost) + " Coins"
	elif coin_cost > 0:
		label.text = str(coin_cost) + " Coins"
		label.visible = true
		label.modulate = Color.WHITE
	else:
		label.visible = false

var tween : Tween
@export var label_off_time : float
func _leave_nearest() -> void:
	if label.visible:
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(label, "modulate", Color(1, 1, 1, 0), label_off_time)
		tween.tween_callback(_hide_label)

func _hide_label() -> void:
	label.visible = false
	label.modulate = Color.WHITE
