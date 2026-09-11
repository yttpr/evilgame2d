class_name SuicideButton

extends TextureButton

@export var handler : MenuHandler
@export var death_quotes : Array[String]

func _botton_pressed() -> void:
	if !Manager.Player:
		return
	Manager._unpause()
	#handler.suicided = true
	Manager.Player.death_quotes = death_quotes
	Manager.Player._get_hit(ceili(Manager.Player.items._check_items("MaxHP", Manager.current_chara.HP, Manager.current_chara)), "NULL", "Item", Vector2.from_angle(randf_range(0.0, 2*PI)) * 500)
	Manager.Player.dead_cooldown = 0.0
	#handler._enter(true)
	await get_tree().create_timer(2).timeout
	_go_home()

func _go_home() -> void:
	Manager._unpause()
	get_tree().change_scene_to_file(Manager.origin_scene)
	Manager._reset_points()
	Manager._reset_run_data()
	Manager.coins = 0
	Manager.wip_coins = 0
	Manager.spawn_loc = 0
	Manager.current_weapons.assign(Manager.current_chara.base_weapons)
	if Manager.current_gun_index >= Manager.current_weapons.size():
		Manager.current_gun_index = 0
	Manager.Player.items._clear_items()
