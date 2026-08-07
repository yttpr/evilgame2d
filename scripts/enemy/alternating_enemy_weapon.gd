class_name AlternatingEnemyWeapon

extends EnemyWeapon


func _ready() -> void:
	super._ready()
	if randf_range(0.0, 1.0) < 0.5:
		damage_type = "Sin"
	else:
		damage_type = "Cos"
	_update_color()

func _shoot(direction : Vector2) -> void:
	super._shoot(direction)
	
	if damage_type == "Sin":
		damage_type = "Cos"
	else:
		damage_type = "Sin"
	_update_color()
