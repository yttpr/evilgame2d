class_name GlobalAudio

extends AudioStreamPlayer

func _play_sound(sound : AudioStream, mod : float = 0.0, pitch : float = 1.0) -> void:
	self.stream = sound
	self.volume_db = -10 + -10.0 * (1.0 - Manager.noise_vol) + mod
	self.pitch_scale = pitch
	self.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus = "Noise"
