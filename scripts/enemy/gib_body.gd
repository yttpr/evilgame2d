class_name GibBody

extends CharacterBody2D

@export var img : Sprite2D
@export var start_height : float = -15.0

var start_tick : int = -1
var tick_time : int = 5

var time : float
var height : float = -35.0

var weight : float = 1.0

var floats : bool = false

func _set_lifetime(delta : float) -> void:
	var up = Manager._get_world().get_tree().create_tween()
	up.set_ease(Tween.EASE_IN)
	up.tween_property(img, "scale", Vector2.ZERO, delta)
	up.tween_callback(self.queue_free)
func _remove(delta : float) -> void:
	var up = Manager._get_world().get_tree().create_tween()
	up.set_ease(Tween.EASE_IN)
	up.tween_property(img, "modulate", Color(1.0, 1.0, 1.0, 0.0), delta)
	up.tween_callback(self.queue_free)

func _randomize_scale() -> void:
	var num = randf_range(1.0, 2.0)
	img.scale = Vector2(num, num)
func _random_rotate() -> void:
	img.rotation = randf_range(0.0, 2 * PI)
func _random_flip() -> void:
	if randf_range(0.0, 1.0) < 0.5:
		img.flip_h = true

var offset : float
func _prep(inertia : Vector2, vertical : bool = false) -> void:
	start_tick = Manager._get_world().ticks
	
	var spd = randf_range(10, 75)
	if inertia.length() > 200:
		spd = randf_range(spd, inertia.length() / 3)
		inertia = inertia.normalized() * randf_range(200, inertia.length())
	
	velocity = Vector2.from_angle(randf_range(0.0, 2 * PI)) * spd + (inertia)
	velocity /= weight
	time = randf_range(0.1, 0.5)
	var moving = Manager._get_world().get_tree().create_tween()
	moving.tween_property(self, "velocity", Vector2(0, 0), time)
	
	if !vertical:
		return
	var i = start_height + randf_range(-8.0, 5.0)
	img.position = Vector2(0.0, i)
	var up = Manager._get_world().get_tree().create_tween()
	up.set_ease(Tween.EASE_OUT)
	up.set_trans(Tween.TRANS_SINE)
	offset = randf_range(0, height) + i
	up.tween_property(img, "position", Vector2(0.0, offset), time / 1.8)
	if !floats:
		up.tween_callback(_down)
	else:
		up.tween_callback(_hover_up)

func _down() -> void:
	var down = Manager._get_world().get_tree().create_tween()
	down.set_ease(Tween.EASE_IN)
	down.set_trans(Tween.TRANS_SINE)
	down.tween_property(img, "position", Vector2.ZERO, time / 1.8)
	if fall_in_pit:
		down.tween_callback(_check_pit)

func _process(delta : float) -> void:
	move_and_slide()
	if start_tick < 0:
		return
	if Manager._get_world().ticks >= start_tick + tick_time:
		if self.global_position.distance_to(Manager.Player.global_position) < 1000:
			tick_time += 3
		else:
			tick_time += 5
			_remove(8)

var fall_in_pit : bool
func _set_fall_in_pit(value : bool = true) -> void:
	fall_in_pit = value

func _check_pit() -> void:
	if Manager._check_in_pit(self):
		_fall()

func _fall() -> void:
	if Manager._get_world().water_pits:
		self.z_index = -3
		var splash = Manager.water_splash.instantiate()
		Manager._get_world().add_child(splash)
		splash.scale = Vector2.ONE * 0.3
		splash.global_position = self.global_position
		Manager._play_oneshot(self.global_position, Manager.splash_noise, 10)
	var down = Manager._get_world().get_tree().create_tween()
	down.tween_property(img, "scale", Vector2.ZERO, 1.0)
	if Manager._check_in_pit_top(self):
		down.parallel().tween_property(img, "position", img.position + Vector2(0, 32), 1.0)
	down.tween_callback(self.queue_free)



var hovertime : float = 0.0

func _hover_up() -> void:
	if hovertime <= 0:
		hovertime = randf_range(3, 5)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(img, "position", Vector2(0, 12 + offset), hovertime)
	tween.tween_callback(_hover_down)

func _hover_down() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(img, "position", Vector2(0, offset), hovertime)
	tween.tween_callback(_hover_up)
