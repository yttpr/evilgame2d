class_name MusicAudio

extends AudioStreamPlayer

@export var ambience : Array[AudioStream]
@export var ambi_vols : Array[float]
var current_ambient_index : int
func _next_song() -> void:
	if Manager.world and Manager._get_world().songs:
		ambience = Manager._get_world().songs
		current_ambient_index = randi_range(0, ambience.size() - 1)


@export var noise : BasicAudio

func _play_sound(sound : AudioStream, mod : float = 0.0, pitch : float = 1.0) -> void:
	self.stream = sound
	self.volume_db = -10 + mod
	self.pitch_scale = pitch
	self.play()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus = "Music"
	current_ambient_index = randi_range(0, ambience.size() - 1)

var play_ambience : bool
func _set_ambience(value : bool) -> void:
	play_ambience = value

func _process(delta: float) -> void:
	if play_ambience:
		if !playing:
			_play_sound(ambience[current_ambient_index], ambi_vols[current_ambient_index])
			_next_song()
