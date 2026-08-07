class_name AcceleratingProjectile

extends MovingProjectile

@export var speed_cap : float = 10000
@export var point : bool
@export var accelration_rate : float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	if body.velocity.length() < speed_cap:
		body.velocity += body.velocity * delta * accelration_rate


func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	if point:
		img.rotation = direction.angle()
