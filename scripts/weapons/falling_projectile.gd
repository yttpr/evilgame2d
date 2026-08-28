class_name FallingProjectile

extends BasicProjectile

##if false, track mouse
@export var track_player : bool

@export var marker : Sprite2D
@export var falling : Sprite2D
@export var delay : float
@export var height : float

@export var radius : float
@export var hit_time : float
@export var bomb_sound : AudioStream
@export var bomb_mod : float

func _set_basic_data(amt : int, t : String, knock : float) -> void:
	super._set_basic_data(amt, t, knock)
	marker.modulate = tracer_color
	falling.modulate = tracer_color

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	y_change = 0
	if track_player:
		self.global_position = Manager.Player.global_position
	else:
		self.global_position = to_global(get_local_mouse_position())
	
	
	
	falling.position = Vector2(0, height)
	var down = get_tree().create_tween()
	down.set_ease(Tween.EASE_IN)
	down.set_trans(Tween.TRANS_SINE)
	down.tween_property(falling, "position", Vector2.ZERO, delay)
	down.tween_callback(_trigger)

func _trigger() -> void:
	Manager._play_oneshot(self.global_position, bomb_sound, bomb_mod)
	_make_collision()
	_cleanup()

func _make_collision() -> void:
	var collider = Manager._create_dmg_collider(dmg, type, source, Vector2.ONE * knockback_mod)
	collider.radial_knockback = true
	collider._set_to_world()
	collider.global_position = self.global_position
	collider._set_pierce(-1)
	collider._set_circle(radius)
	collider._set_duration(true, hit_time)
	collider._set_collision(damager)
	collider.death_quote = death_quote

@export var increase_gib_size : bool = true
func _make_gibs() -> void:
	var gib = Manager._make_bullet_gib(self.global_position, _offset(), tracer_color)
	if increase_gib_size:
		gib.scale = Vector2.ONE * 3
