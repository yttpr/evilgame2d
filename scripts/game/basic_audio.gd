class_name BasicAudio

extends AudioStreamPlayer2D

@export var ignore_pause : bool

var oneshot : bool

func _play_sound(sound : AudioStream, mod : float = 0.0, pitch : float = 1.0) -> void:
	if !sound:
		return
	self.stream = sound
	self.volume_db = -10 + -10.0 * (1.0 - Manager.noise_vol) + mod
	if pitch <= 0.0:
		pitch = 0.001
	self.pitch_scale = pitch
	self.play()

func _set_oneshot(val : bool = true) -> void:
	oneshot = val

var is_paused : bool
var paused_at : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attenuation = 5
	is_paused = false
	bus = "Noise"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if oneshot and !self.playing:
		self.queue_free()
	
	if Manager.is_paused and !is_paused and playing:
		is_paused = true
		paused_at = get_playback_position()
		stop()
	elif !Manager.is_paused and is_paused:
		is_paused = false
		play(paused_at)
