class_name ExitButton

extends TextureButton

func _botton_pressed() -> void:
	if Manager.Player.dead_cooldown > 0:
		return
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
