class_name HealPotItem

extends BasicItem


func _perform_active() -> void:
	Manager.current_hp = ceili(Manager.Player.items._check_items("MaxHP", Manager.current_chara.HP, Manager.current_chara, Manager.Player))
	var amt = Manager.current_hp - Manager.Player.HP
	Manager.Player.HP = Manager.current_hp
	Manager.Player.ui.Health._set_current_health(Manager.current_hp)
	Manager._play_oneshot(Manager.Player.global_position, ResourceLoader.load("res://audio/noise/ui/ui_heal.mp3"), 10.0)
	Manager._make_heal_popup(amt, Manager.Player.global_position, Manager.Player.healthtype == "Sin")
