class_name OnDamageUnloadItem

extends BasicItem

func _pass(parameter : String, input : Variant, args : Variant, caller : Node2D) -> Variant:
	if parameter == "OnHit":
		handler.Player.weapon_handler.current_clip = 0
		handler.Player.weapon_handler.reload_tick = 0
		handler.Player.ui.Ammo._set_loaded_amt(0)
		handler.Player.weapon_handler._set_reload(true)
	return super._pass(parameter, input, args, caller)
