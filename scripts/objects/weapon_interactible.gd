class_name WeaponInteractible

extends BaseInteractible

@export var weapon : WeaponData
@export var image : Sprite2D
@export var max_hotbar_size : int

func _ready() -> void:
	image.texture = weapon.weapon_img
	label.visible = false

@export var health_cost : int
@export var coin_cost : int

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
	else:
		Manager.Player.weapon_handler._add_weapon(weapon)
		self.queue_free()

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
