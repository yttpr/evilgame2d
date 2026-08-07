class_name BasicProjectile

extends Node2D

@export var type : String
@export var dmg : int
@export var source : String
@export var knockback_mod : float = 1.0
@export var pierce_amt : int

@export var bouncer : CollisionObject2D
@export var damager : CollisionObject2D

@export var by_distance : bool
@export var distance : float
@export var by_lifetime : bool
@export var lifetime : float

@export var y_change : float
func _offset() -> Vector2:
	return Vector2(0, y_change)

@export var tracer_width : float
@export var tracer_color : Color
@export var tracer_time : float

@export var shot_sound : AudioStream
@export var audio_mod : float
@export var pitch_mod : float = 1.0

@export var make_gibs : bool

@export var death_quote : Array[String]

func _set_basic_data(amt : int, t : String, knock : float) -> void:
	dmg = amt
	type = t
	knockback_mod = knock
	
	if type == "Cos":
		tracer_color = Manager.cos_color
	elif type == "Sin":
		tracer_color = Manager.sin_color

func _set_collision(s: String, b: CollisionObject2D = null, d: CollisionObject2D = null) -> void:
	source = s
	bouncer = b
	damager = d
	
	if !bouncer:
		bouncer = Manager.collision_walls
	if !damager:
		damager = Manager.collision_all

func _shoot(direction : Vector2, origin : Vector2) -> void:
	Manager._play_oneshot(origin, shot_sound, audio_mod, pitch_mod)
	lastPos = origin

func _draw_tracer(orig : Vector2, pos : Vector2) -> void:
	if tracer_time <= 0:
		return
	
	if pos.y > orig.y:
		var temp = pos
		pos = orig
		orig = temp
	
	var line = Line2D.new()
	Manager._get_world().add_child(line)
	line.global_position = orig - _offset()
	line.global_rotation = 0
	#line.position = self.position
	line.add_point(Vector2.ZERO + _offset())
	line.add_point((pos - _offset()) - line.global_position + _offset())
	line.width = tracer_width
	line.modulate = tracer_color
	line.material = Manager._tracer_mat()
	line.y_sort_enabled = true
	line.show_behind_parent = true
	
	# tween
	var tween = get_tree().create_tween()
	tween.tween_property(line, "width", 0, tracer_time)
	tween.tween_callback(line.queue_free)
	
	#await get_tree().create_timer(tracer_time).timeout
	#line.queue_free()

var lastPos : Vector2
func _process(delta: float) -> void:
	
	if by_distance:
		var dist = self.global_position - lastPos
		distance -= dist.length()
		if distance <= 0:
			self._cleanup()
	if by_lifetime:
		lifetime -= delta
		if lifetime <= 0:
			self._cleanup()
	
	lastPos = self.global_position

func _hit_made() -> void:
	pass


func _make_gibs() -> void:
	Manager._make_bullet_gib(self.global_position, _offset(), tracer_color)

func _cleanup() -> void:
	if make_gibs:
		_make_gibs()
	self.queue_free()
