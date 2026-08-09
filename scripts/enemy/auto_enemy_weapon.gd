class_name AutoEnemyWeapon

extends EnemyWeapon

@export var timer : float
var tick : float
var toggle : bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tick -= delta
	if tick <= 0:
		tick = timer
		if toggle:
			_shoot(Vector2.DOWN)
			_shoot(Vector2.LEFT)
			_shoot(Vector2.RIGHT)
			_shoot(Vector2.UP)
		else:
			_shoot(Vector2(1, 1).normalized())
			_shoot(Vector2(1, -1).normalized())
			_shoot(Vector2(-1, -1).normalized())
			_shoot(Vector2(-1, 1).normalized())
		toggle = !toggle
	
	is_agro = false
	brain._set_moving(true)
