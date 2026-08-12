class_name FlipSelfHealthAutoWeapon

extends AutoEnemyWeapon

@export var body : BaseBody

func _flip() -> void:
	if body.healthtype == "Sin":
		body.healthtype = "Cos"
	else:
		body.healthtype = "Sin"
	body._update_marker()


func _made_shot() -> void:
	super._made_shot()
	_flip()
