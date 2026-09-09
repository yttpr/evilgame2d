class_name AutoReloaderItem

extends BasicItem


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	var amt = float(Manager.Player.weapon_handler.reload_lefts.size())
	for i in amt:
		if Manager.Player.weapon_handler.reload_lefts[i] > 0:
			Manager.Player.weapon_handler.reload_lefts[i] -= delta / amt
			if Manager.Player.weapon_handler.reload_lefts[i] <= 0:
				Manager.Player.weapon_handler.remaining_clips[i] = ceili(Manager.Player.items._check_items("MaxClip", Manager.Player.weapon_handler.weapons[i].clip_size, Manager.Player.weapon_handler.weapons[i], self))
