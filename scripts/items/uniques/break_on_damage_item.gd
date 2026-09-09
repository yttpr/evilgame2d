class_name BreakOnDamageItem

extends BasicItem

func _pass(parameter : String, input : Variant, args : Variant, caller : Node2D) -> Variant:
	if parameter == "OnHit":
		self._destroy_item()
	return super._pass(parameter, input, args, caller)
