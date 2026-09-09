class_name BasicItem

extends Node2D

@export var handler : ItemHandler

@export var data : ItemData
@export var slot_index : int

##string : float
@export var addition_mod : Dictionary[String, float]

##string : float
@export var multi_mod : Dictionary[String, float]

func _pass(parameter : String, input : Variant, args : Variant, caller : Node2D) -> Variant:
	if addition_mod.has(parameter):
		input += addition_mod[parameter]
	if multi_mod.has(parameter):
		input *= multi_mod[parameter]
	return input

func _initialize() -> void:
	#await get_tree().process_frame
	if data.reset_player:
		handler._reset_player()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_tick = 0.0


@export var inert : bool
##DO NOT OVERRIDE
func _try_perform_active() -> void:
	if inert:
		_fail_activation()
		return
	if cooldown_tick > 0:
		_show_on_cooldown()
		return
	if data.check_player_health and _check_player_health():
		_show_at_full_health()
		return
	if data.cost_type == "Heart" and data.cost_amt >= Manager.current_hp:
		_show_not_enough_health()
		return
	if data.cost_type == "Coin" and data.cost_amt > Manager.coins:
		_show_not_enough_money()
		return
	
	_perform_active()
	
	_process_cost()

func _process_cost() -> void:
	if data.cost_type == "Heart":
		Manager.Player._get_hit(floori(data.cost_amt), "NULL", "Item", Vector2.ZERO)
	elif data.cost_type == "Coin":
		Manager._play_oneshot(self.global_position, Manager.purchase_noise, 6.0)
		Manager.coins -= floori(data.cost_amt)
	elif data.cost_type == "Cooldown":
		cooldown_tick = data.cost_amt
	elif data.cost_type == "Item":
		_destroy_item()
##OVERRIDE THIS
func _perform_active() -> void:
	pass


func _destroy_item() -> void:
	handler._break_item()
	handler._set_item(slot_index, null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var cooldown_tick : float
func _physics_process(delta: float) -> void:
	if cooldown_tick > 0:
		cooldown_tick -= delta

func _check_player_health() -> bool:
	return Manager.current_hp >= ceili(Manager.Player.items._check_items("MaxHP", Manager.current_chara.HP, Manager.current_chara, Manager.Player))
func _show_at_full_health() -> void:
	handler._trigger_label("At full health!")
	_fail_activation()
func _show_not_enough_health() -> void:
	handler._trigger_label("Not enough health!")
	_fail_activation()
func _show_not_enough_money() -> void:
	handler._trigger_label("Not enough coins!")
	_fail_activation()
func _show_on_cooldown() -> void:
	handler._trigger_label("On cooldown!")
	_fail_activation()
func _fail_activation() -> void:
	Manager._play_oneshot(Manager.Player.global_position, Manager.ui_fail, 20)
