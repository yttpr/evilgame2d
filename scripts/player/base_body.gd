class_name BaseBody

extends CharacterBody2D

@export var sprites : Sprite2D

@export var HP : int = 1
@export var healthtype : String
@export var points : int = 1
@export var gibs : GibData
@export var hit_sound : AudioStream
@export var hit_mod : float

var audio : BasicAudio

@export var marker : Sprite2D

@export var i_frame_time : float = 0.15
var i_frames : Dictionary

@export var mov_spd : int = 250
@export var inertia_decay : float = 0.6
var inertia : Vector2

@export var flies : bool

var is_dead : bool
var is_falling : bool

@export var despawn_time : float = 60.0
@export var despawn_length : float = 9999.0

var despawn_tick

func _ready() -> void:
	inertia = Vector2(0, 0)
	is_dead = false
	despawn_tick = despawn_time
	
func _update_marker() -> void:
	if marker:
		marker.self_modulate = Color.WHITE
		if healthtype == "Sin":
			marker.modulate = Manager.sin_color
		elif healthtype == "Cos":
			marker.modulate = Manager.cos_color

func _add_inertia(dir : Vector2) -> void:
	inertia += dir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_falling:
		return
	
	_make_movement(delta)
	
	if !flies:
		_check_pit()
	
	if despawn_length < 0 or despawn_time < 0:
		return
	
	if despawn_tick <= 0:
		if self.global_position.distance_to(Manager.Player.global_position) > despawn_length:
			_cleanup()
		despawn_tick = despawn_time
	
	despawn_tick -= delta

func _make_movement(delta : float = 0.0) -> void:
	if inertia_decay == 0:
		inertia *= 0
	velocity += inertia
	inertia *= 1.0 - (1.0 - inertia_decay) * delta * 60
	if inertia.length() < 0.5:
		inertia = Vector2.ZERO
	move_and_slide()

func _die() -> void:
	if is_dead:
		return
	_on_die()
	_cleanup()

func _cleanup() -> void:
	is_dead = true
	Manager._get_world().Enemies.erase(self)
	self.queue_free()

func _on_die() -> void:
	#print(self.name, " is dead")
	Manager._add_points(points)
	if gibs:
		Manager._make_gibs(self.global_position, inertia, gibs)

func _get_hit(amt : int, type : String, source : String, mov : Vector2, extra : bool = false) -> bool:
	if !_check_i_frame(source):
		return false
	if !_can_hit(amt, type, source):
		return false
	amt = _modify_hit(amt, type, source)
	inertia += mov
	HP -= amt
	Manager._make_damage_popup(amt, self.global_position, healthtype == "Sin")
	if hit_sound:
		_hit_sound(amt)
	_on_hit(amt, type, source)
	if HP <= 0:
		_die()
	return true

func _on_hit(amt : int, type : String, source : String) -> void:
	pass
func _can_hit(amt : int, type : String, source : String) -> bool:
	return true
func _modify_hit(amt : int, type : String, source : String) -> int:
	if type == "NULL":
		return amt
	if type != healthtype:
		amt *= 2
		Manager._create_weak(self.global_position, healthtype == "Sin")
	return amt


func _check_i_frame(source : String) -> bool:
	if source.contains("0"):
		return true
	if !i_frames:
		i_frames = {}
	
	if !i_frames.has(source):
		i_frames.set(source, i_frame_time)
	elif i_frames[source] > 0:
		return false
	
	return true

func _process(delta: float) -> void:
	
	#i frame logic
	
	if !i_frames:
		return
	var keys = i_frames.keys()
	for key in keys:
		i_frames[key] = i_frames[key] - delta
		if i_frames[key] <= 0:
			i_frames.erase(key)

func _hit_sound(amt : int) -> void:
	if !audio:
		audio = BasicAudio.new()
		Manager._get_world().add_child(audio)
	audio.global_position = self.global_position
	audio._play_sound(hit_sound, hit_mod, 1.5 - (amt / 10.0))



func _check_pit() -> void:
	if is_dead: 
		return
	if Manager._check_in_pit(self):
		_fall()

func _fall() -> void:
	is_falling = true
	is_dead = true
	var down = get_tree().create_tween()
	down.tween_property(sprites, "scale", Vector2.ZERO, 1.0)
	if Manager._check_in_pit_top(self):
		down.parallel().tween_property(sprites, "position", sprites.position + Vector2(0, 32), 1.0)
	down.tween_callback(self._cleanup)


@export var cause_darkening : bool
