class_name ItemDisplay

extends Node2D

@export var active : WeaponPortrait
@export var passives : Array[WeaponPortrait]
@export var pointer : Node2D
@export var on_active : Node2D
@export var pointer_a_rate : float = 2.0

@export var active_c : Color
@export var inactive_c : Color

var active_index : int = 0

var apointer_tick : float
var pointer_tick : float

func _ready() -> void:
	pointer.modulate.a = 0.0
	on_active.modulate.a = 0.0
	await get_tree().process_frame
	if Manager.Player.items._has_items():
		self.modulate = Color.WHITE
	else:
		self.modulate.a = 0.0

var self_tick : float
func _process(delta: float) -> void:
	if Manager.Player.items._has_items():
		self_tick = 8.0
		self.modulate = Color.WHITE
	elif self_tick > 0.0:
		self_tick -= delta
	elif pointer_tick <= 0.0 and apointer_tick <= 0.0:
		self.modulate.a = max(0.0, self.modulate.a - pointer_a_rate * delta)
	
	if pointer_tick > 0:
		pointer_tick -= delta
		pointer.modulate.a = min(1.0, pointer.modulate.a + pointer_a_rate * delta)
		self.modulate.a = min(1.0, self.modulate.a + pointer_a_rate * delta)
	else:
		pointer.modulate.a = max(0.0, pointer.modulate.a - pointer_a_rate * delta)
	
	if apointer_tick > 0:
		apointer_tick -= delta
		on_active.modulate.a = min(1.0, on_active.modulate.a + pointer_a_rate * delta)
		self.modulate.a = min(1.0, self.modulate.a + pointer_a_rate * delta)
	else:
		on_active.modulate.a = max(0.0, on_active.modulate.a - pointer_a_rate * delta)
	
	_update_colors()
	_update_cooldowns()

func _update_colors() -> void:
	for passive in passives:
		passive.modulate = inactive_c
	if pointer_tick > 0 or pointer.modulate.a > 0.5:
		passives[active_index].modulate = active_c
	if apointer_tick > 0 or on_active.modulate.a > 0.5:
		active.modulate = active_c
	else:
		active.modulate = inactive_c
func _update_cooldowns() -> void:
	if !Manager.Player.items.active or Manager.Player.items.active.data.cost_type != "Cooldown":
		active.cooldown.scale.y = 0.0
	elif Manager.Player.items.active.cooldown_tick > 0:
		active.cooldown.scale.y = Manager.Player.items.active.cooldown_tick / Manager.Player.items.active.data.cost_amt
	else:
		active.cooldown.scale.y = 0.0
	for i in passives.size():
		if !Manager.Player.items.passives[i] or Manager.Player.items.passives[i].data.cost_type != "Cooldown":
			passives[i].cooldown.scale.y = 0.0
		elif Manager.Player.items.passives[i].cooldown_tick > 0:
			passives[i].cooldown.scale.y = Manager.Player.items.passives[i].cooldown_tick / Manager.Player.items.passives[i].data.cost_amt
		else:
			passives[i].cooldown.scale.y = 0.0

func _point_passive(index : int) -> void:
	if index >= passives.size() or index < 0:
		return
	active_index = index
	pointer.get_parent().remove_child(pointer)
	passives[index].add_child(pointer)
	pointer.position = Vector2.ZERO
	pointer.scale = Vector2.ONE * 0.5

func _enable_pointer(active : bool) -> void:
	if active:
		apointer_tick = 2.0
	else:
		pointer_tick = 2.0


# cost type icon setting
@export var health_cost : Texture2D
@export var coin_cost : Texture2D
@export var cooldown_cost : Texture2D
@export var item_cost : Texture2D
@export var danger_cost : Texture2D

func _set_item_data() -> void:
	if !Manager.Player.items.active:
		active.weapon.texture = null
		active.type.texture = null
	else:
		active.weapon.texture = Manager.Player.items.active.data.image
		_set_item_cost(active, Manager.Player.items.active.data)
	
	for i in passives.size():
		if !Manager.Player.items.passives[i]:
			passives[i].weapon.texture = null
			passives[i].type.texture = null
		else:
			passives[i].weapon.texture = Manager.Player.items.passives[i].data.image
			_set_item_cost(passives[i], Manager.Player.items.passives[i].data)

func _set_item_cost(display : WeaponPortrait, data : ItemData) -> void:
	if data.cost_type == "Heart":
		display.type.texture = health_cost
		if Manager.Player.healthtype == "Sin":
			display.type.modulate = Manager.sin_color
		elif Manager.Player.healthtype == "Cos":
			display.type.modulate = Manager.cos_color
		else:
			display.type.modulate = Color.WHITE
	elif data.cost_type == "Coin":
		display.type.texture = coin_cost
		display.type.modulate = Color.from_rgba8(242, 214, 0)
	elif data.cost_type == "Cooldown":
		display.type.texture = cooldown_cost
		display.type.modulate = Color.WHITE
	elif data.cost_type == "Item":
		display.type.texture = item_cost
		display.type.modulate = Color.WHITE
	elif data.cost_type == "Danger":
		display.type.texture = danger_cost
		display.type.modulate = Color.WHITE
	else:
		display.type.texture = null
