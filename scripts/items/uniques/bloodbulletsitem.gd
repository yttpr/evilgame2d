class_name BloodBulletsItem

extends BasicItem


func _pass(parameter : String, input : Variant, args : Variant, caller : Node2D) -> Variant:
	if parameter == "EnemyDie":
		if handler.Player.weapon_handler.current_clip < handler.Player.weapon_handler.max_clip:
			handler.Player.weapon_handler.current_clip += 1
			handler.Player.ui.Ammo._set_loaded_amt(handler.Player.weapon_handler.current_clip)
	return super._pass(parameter, input, args, caller)
