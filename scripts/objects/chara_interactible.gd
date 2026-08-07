extends BaseInteractible

@export var chara : CharacterData
@export var image : Sprite2D
@export var noise : AudioStream

func _ready() -> void:
	self.image.texture = chara.image

func _run() -> void:
	var old = Manager.Player.data
	Manager.Player._set_data(chara)
	Manager.Player.weapon_handler._reset_arrays()
	chara = old
	self.image.texture = chara.image
	
	var s = global_position
	self.global_position = Manager.Player.global_position
	Manager.Player.global_position = s
	
	Manager._play_oneshot(Manager.Player.global_position, noise, 6)

var processed : bool
func _process(delta: float) -> void:
	if processed:
		return
	if Manager.Player.data == chara:
		chara = ResourceLoader.load("res://assets/characters/saturn_character.tres")
		self.image.texture = chara.image
	processed = true
