class_name QuickReloadItem

extends BasicItem

func _try_perform_active() -> void:
	if handler.Player.weapon_handler.current_clip >= handler.Player.weapon_handler.max_clip and cooldown_tick <= 0.0:
		handler._trigger_label("Already full ammo!")
		_fail_activation()
		return
	super._try_perform_active()
func _perform_active() -> void:
	handler.Player.weapon_handler.reload_tick = 0.0
	handler.Player.weapon_handler._set_reload(false)
