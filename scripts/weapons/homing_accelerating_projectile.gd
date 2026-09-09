class_name HomingAcceleratingProjectile

extends HomingProjectile

@export var speed_cap : float = 10000
@export var point : bool
@export var accelration_rate : float = 1.0

@export var accelerate_only_on_mouse : bool
@export var extra_mouse_logic : bool
@export var extra_mouse_rate : float = 3.0
@export var img_accel_rate : float = 1.2

var mouse_triggered : bool
@export var release_sound : AudioStream
@export var release_mod : float

@export var increase_pierce_time : float
var inc_p_tick : float
@export var set_tracer_time : float
@export var tracer_threshold : float

#chargeup audio
@export var charge_audio : BasicAudio
@export var chargeup_sound : AudioStream
@export var charge_sound_mod : float
@export var charge_sound_min_pitch : float
@export var charge_sound_max_pitch : float

@export var make_afterimages : bool
@export var after_image_time : float = 0.15
var afterimage_tick : float

func _ready() -> void:
	super._ready()
	inc_p_tick = increase_pierce_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !extra_mouse_logic or mouse_triggered:
		super._process(delta)
	else:
		if img_rotate_spd != 0.0:
			img.rotate(img_rotate_spd * delta)
	
	if !accelerate_only_on_mouse:
		if body.velocity.length() < speed_cap:
			body.velocity += body.velocity * delta * accelration_rate
		#else:
			#print(source + " at speed cap")
	if extra_mouse_logic and Manager.Player.weapon_handler.mouse_down and !mouse_triggered:
		if body.velocity.length() < speed_cap:
			body.velocity += body.velocity * delta * extra_mouse_rate
		self.global_position = Manager.Player.weapon_handler.pointer.global_position - _offset()
		body.velocity = body.velocity.length() * Manager.Player.weapon_handler.weapon.global_position.direction_to(to_global(get_local_mouse_position()))
		collider.inertia = body.velocity.normalized() * knockback_mod
		make_backup_colliders = false
		if img_rotate_spd != 0.0:
			img_rotate_spd += img_rotate_spd * (img_accel_rate - 1.0) * delta
		inc_p_tick -= delta
		if inc_p_tick <= 0:
			inc_p_tick = increase_pierce_time
			pierce_amt += 1
		if !charge_audio.playing and chargeup_sound:
			charge_audio._play_sound(chargeup_sound, charge_sound_mod, charge_sound_min_pitch)
		elif chargeup_sound:
			charge_audio.pitch_scale = charge_sound_min_pitch + (body.velocity.length() / speed_cap) * (charge_sound_max_pitch - charge_sound_min_pitch)
	elif make_afterimages:
		if delta > 0:
			var im = Manager._make_afterimage(img, after_image_time)
	if !Manager.Player.weapon_handler.mouse_down and !mouse_triggered:
		mouse_triggered = true
		make_backup_colliders = true
		charge_audio.stop()
		if body.velocity.length() > tracer_threshold:
			tracer_time = set_tracer_time
			make_afterimages = false
		Manager._play_oneshot(self.global_position, release_sound, release_mod)


func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	if point:
		img.rotation = direction.angle()
