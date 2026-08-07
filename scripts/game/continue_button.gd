class_name ContinueButton

extends TextureButton

func _botton_pressed() -> void:
	if Manager.in_menu:
		if Manager.Player.is_dead:
			if Manager.Player.dead_cooldown > 0:
				return
			Manager._unpause()
			get_tree().change_scene_to_file(Manager.origin_scene)
			Manager._reset_points()
			Manager._reset_run_data()
			Manager.coins = 0
			Manager.current_weapons.assign(Manager.current_chara.base_weapons)
			if Manager.current_gun_index >= Manager.current_weapons.size():
				Manager.current_gun_index = 0
		else:
			Manager._toggle_pause()
