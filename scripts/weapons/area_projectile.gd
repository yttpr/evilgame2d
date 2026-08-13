class_name AreaProjectile

extends BasicProjectile
@export var img : Sprite2D
@export var outline : Sprite2D

@export var radius : float
@export var lasts : float
@export var delay : float
var tick : float

@export var anim_spd : float
var a_tick : float

@export var extra_sound : AudioStream
@export var extra_mod : float
@export var extra_audio : BasicAudio

@export var player_only : bool

func _ready() -> void:
	tick = 0
	a_tick = anim_spd

func _process(delta: float) -> void:
	super._process(delta)
	
	tick -= delta
	if tick < 0:
		tick = delay
		_make_collider()
	
	if img.hframes > 1:
		a_tick -= delta
		if a_tick < 0:
			a_tick = anim_spd
			if img.frame >= img.hframes - 1:
				img.frame = 0
			else:
				img.frame += 1
			if outline:
				outline.frame = img.frame

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	extra_audio._play_sound(extra_sound, extra_mod)
	self.global_position = origin - _offset() + Vector2.from_angle(randf_range(0, 2*PI)) * randf_range(0, 10)
	if !Manager._get_world().water_pits and Manager._check_in_pit(img):
		_cleanup()
	img.modulate = tracer_color

func _make_collider() -> DamageCollider:
	var collider = Manager._create_dmg_collider(dmg, type, source, Vector2.ZERO)
	collider.radial_knockback = true
	collider._set_parent(self)
	collider._set_pierce(-1)
	collider._set_circle(radius)
	collider._set_duration(true, lasts)
	if !player_only:
		collider._set_collision(Manager.collision_all)
	else:
		collider._set_collision(Manager.collision_forEnemy)
	collider.frame_buffer = 5
	collider.death_quote = death_quote
	return collider

func _cleanup() -> void:
	extra_audio.stop()
	super._cleanup()
