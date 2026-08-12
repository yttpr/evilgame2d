class_name RandomVariationProjectile

extends MovingProjectile

@export var variation : float

@export var spd_mod : float

@export var deceleration_rate : float = 1.0
@export var die_if_stop : bool

func _shoot(direction : Vector2, origin : Vector2) -> void:
	spd *= (1.0 + randf_range(spd_mod * -1, spd_mod))
	var mod = randf_range(variation * -1, variation)
	super._shoot(Vector2.from_angle(direction.angle() + mod), origin)

func _process(delta: float) -> void:
	super._process(delta)
	if deceleration_rate < 1.0:
		body.velocity *= 1.0 - (1.0 - deceleration_rate) * delta * 60
		if body.velocity.length() < 60:
			if die_if_stop:
				self._cleanup()
			else:
				body.velocity = Vector2.ZERO
