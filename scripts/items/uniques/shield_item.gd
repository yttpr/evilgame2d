class_name ShieldItem

extends BasicItem

func _pass(parameter : String, input : Variant, args : Variant, caller : Node2D) -> Variant:
	if parameter == "CanHit" and input and (cooldown_tick <= 0.0 or iframes > 0.0):
		if args.type == "NULL":
			return true
		if cooldown_tick <= 0.0:
			iframes += 0.05
		Manager._play_oneshot(Manager.Player.global_position, ResourceLoader.load("res://audio/noise/ui/ui_block.wav"), 6.0)
		for i in args.amt:
			_make_shield()
		
		_process_cost()
		return false
	
	return super._pass(parameter, input, args, caller)

var iframes : float = 0.0
func _process(delta: float) -> void:
	super._process(delta)
	if iframes > 0.0:
		iframes -= delta
func _make_shield() -> void:
	var icon : DamageIcon = preload("res://assets/ui/shield_icon.tscn").instantiate()
	Manager._get_world().add_child(icon)
	icon.global_position = Manager.Player.global_position
	icon._begin()
	icon._set_color(Manager.Player.healthtype == "Sin")
	icon._animate()
