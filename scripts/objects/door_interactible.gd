class_name DoorInteractible

extends BaseInteractible

@export var room : String
@export var spawn_pos : int

@export var locked : bool

func _run() -> void:
	if locked:
		Manager._play_oneshot(self.global_position, Manager.door_shake, 12)
		#Music.noise._play_sound(Manager.door_shake, 20)
		return
	Manager.current_weapons.assign(Manager.Player.weapon_handler.weapons)
	Manager.spawn_loc = spawn_pos
	#Music.noise._play_sound(Manager.door_noise, 15)
	get_tree().change_scene_to_file(room)

func _check_pit() -> void:
	return
