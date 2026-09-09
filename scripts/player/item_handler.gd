class_name ItemHandler

extends Node2D

@export var Player : PlayerBody
@export var interaction : InteractionZone

@export var active : BasicItem

@export var max_passives : int = 2
@export var passives : Array[BasicItem]
var selected_passive : int = -1

@export var label : Label
var is_ready : bool = false

func _ready() -> void:
	label.visible = false
	if passives.size() != max_passives:
		passives.resize(max_passives)
	if selected_passive < 0:
		selected_passive = Manager.current_item_index
	_get_items()
	await get_tree().process_frame
	_set_items()
	is_ready = true

func _has_items() -> bool:
	if active:
		return true
	for i in passives.size():
		if passives[i]:
			return true
	return false

func _check_items(parameter : String, input : Variant, special = null, caller = Manager.Player) -> Variant:
	var hold = input
	for item in passives:
		if !item:
			continue
		hold = item._pass(parameter, hold, special, caller)
	return hold

func _set_item(index : int, data : ItemData) -> void:
	if !data:
		if index == -1:
			if active:
				active.queue_free()
				if active.data.reset_player:
					active = null
					_reset_player()
			active = null
		elif index >= 0 and index < 2:
			if passives[index]:
				passives[index].queue_free()
				if passives[index].data.reset_player:
					passives[index] = null
					_reset_player()
			passives[index] = null
	elif data.active:
		#remove last
		if active:
			active.queue_free()
			if active.data.reset_player:
				active = null
				_reset_player()
		
		if !data:
			return
		#new item
		var obj
		if data.logic:
			obj = (data.logic as GDScript).new()
		else:
			obj = BasicItem.new()
		active = obj
		Player.call_deferred("add_child", active)
		active.handler = self
		active.data = data
		active.slot_index = -1
		active.addition_mod = data.addition_mod
		active.multi_mod = data.multi_mod
		active.inert = data.inert
		active._initialize()
	else:
		if index >= passives.size():
			return
		#remove last
		if passives[index]:
			passives[index].queue_free()
			if passives[index].data.reset_player:
				passives[index] = null
				_reset_player()
		
		if !data:
			return
		#new item
		var obj
		if data.logic:
			obj = (data.logic as GDScript).new()
		else:
			obj = BasicItem.new()
		passives[index] = obj
		Player.call_deferred("add_child", passives[index])
		passives[index].handler = self
		passives[index].data = data
		passives[index].slot_index = index
		passives[index].addition_mod = data.addition_mod
		passives[index].multi_mod = data.multi_mod
		passives[index].inert = data.inert
		passives[index]._initialize()
	_set_items()

var mouse_down : bool
func _input(event: InputEvent) -> void:
	if Player.is_dead or Manager.is_paused or Manager.lock_input:
		mouse_down = false
		return
		
	if event is InputEventMouseButton and event.button_index == 2:
		mouse_down = event.is_pressed()
		
		if mouse_down and active:
			active._try_perform_active()
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_SHIFT:
		_change_selected_passive()


func _reset_player() -> void:
	if !is_ready:
		self.call_deferred("_do_reset_player")
	else:
		_do_reset_player()
func _do_reset_player() -> void:
	# reset player
	Player._set_data(Player.data)
	Player.ui.Health._set_max_health(ceili(_check_items("MaxHP", Player.data.HP, Player.data, self)))
	Player.ui.Health._set_current_health(Player.HP)
	Player.ui.Health._set_health_type(Player.healthtype)
	# reset weapons
	Player.weapon_handler.mouse_down = false
	Player.ui.Weapons._set_weapons_data(Player.weapon_handler.weapons)
	Player.weapon_handler._reset_arrays()
	Player.weapon_handler._set_reload(false)
	Player.weapon_handler._set_data(Player.weapon_handler.weapons[Manager.current_gun_index])
	Player.ui.Weapons._set_active_weapon(Manager.current_gun_index)
	Player.weapon_handler._reset_alt_clip()

func _update_selected_passive() -> void:
	selected_passive = Manager.current_item_index
	Player.ui.Items._point_passive(selected_passive)
	Player.ui.Items._enable_pointer(false)
func _change_selected_passive() -> void:
	selected_passive += 1
	if selected_passive >= passives.size():
		selected_passive = 0
	Player.ui.Items._point_passive(selected_passive)
	Player.ui.Items._enable_pointer(false)
	Manager.current_item_index = selected_passive

func _point_active() -> void:
	Player.ui.Items._enable_pointer(true)

func _process(delta: float) -> void:
	if Player.is_dead or Manager.is_paused or Manager.lock_input:
		mouse_down = false
		return
	if interaction.nearest and interaction.nearest is ItemShopInteractible:
		var shop : ItemShopInteractible = interaction.nearest
		if shop.weapon:
			if shop.weapon.active:
				_point_active()
			else:
				_update_selected_passive()



func _get_items() -> void:
	_set_item(-1, Manager.current_active)
	for i in Manager.current_passives.size():
		_set_item(i, Manager.current_passives[i])

func _set_items() -> void:
	if !Manager.Player:
		return
	if active:
		Manager.current_active = active.data
	else:
		Manager.current_active = null
	Manager.current_passives = []
	Manager.current_passives.resize(2)
	for i in passives.size():
		if passives[i]:
			Manager.current_passives[i] = passives[i].data
		else:
			Manager.current_passives[i] = null
	Player.ui.Items._set_item_data()

func _clear_items() -> void:
	_set_item(-1, null)
	_set_item(0, null)
	_set_item(1, null)

#item break
@export var break_sound : AudioStream
@export var break_mod : float
func _break_item() -> void:
	Manager._play_oneshot(Player.global_position, break_sound, break_mod)


# label shit
var tween : Tween
@export var label_off_time : float
func _trigger_label(desc : String) -> void:
	label.text = desc
	label.visible = true
	label.modulate = Color.WHITE
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
