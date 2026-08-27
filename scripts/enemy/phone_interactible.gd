class_name PhoneInteractible

extends BaseInteractible

@export var enemy : BaseBody

@export var rise_dist : float
@export var rise_time : float

@export var weapon : EnemyWeapon
@export var base_marker : Node2D

@export var light : Node2D

func _run() -> void:
	can_interact = false
	enemy.sprites.light_mask = 0
	#enemy.is_dead = true
	weapon._set_reload(true)
	weapon.reload_tick = 999
	#weapon.is_agro = false
	weapon.aiming_tick = 0
	weapon.process_mode = Node.PROCESS_MODE_DISABLED
	weapon.brain.process_mode = Node.PROCESS_MODE_DISABLED
	weapon.brain._set_moving(false)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(enemy.sprites, "offset", enemy.sprites.offset + Vector2(0, rise_dist * -1), rise_time)
	tween.tween_callback(enemy._cleanup)
	base_marker.visible = false
	Manager._add_points(enemy.points)
	if enemy.gibs:
		Manager.coins += enemy.gibs.coins
		Manager._play_oneshot(Manager.Player.global_position, Manager.coin_noise, 0)
	light.visible = false
	self.queue_free()

func _process(delta: float) -> void:
	super._process(delta)
	if weapon.is_agro and weapon.aiming_tick > 0:
		base_marker.visible = true
	else:
		base_marker.visible = false

func _physics_process(delta: float) -> void:
	self.global_position = enemy.global_position

func _instadie() -> void:
	print("hi???")
	enemy._cleanup()
