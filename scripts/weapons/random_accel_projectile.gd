class_name RandomAccelProjectile

extends MovingProjectile

@export var max_accel : float
@export var change_time : float
@export var change_chance : float
@export var slow_chance : float

@export var life_chance : float
@export var life_inc : float

var tick : float
var accel : Vector2 = Vector2.ZERO

func _ready() -> void:
	tick = 0

func _process(delta: float) -> void:
	super._process(delta)
	
	if tick <= 0:
		tick = change_time
		if randf_range(0.0, 1.0) < change_chance:
			accel = Vector2.from_angle(randf_range(0, 2*PI)) * randf_range(0, max_accel)
			if randf_range(0.0, 1.0) < slow_chance:
				body.velocity /= 2
			if randf_range(0.0, 1.0) < life_chance:
				lifetime += life_inc
	tick -= delta
	body.velocity += accel * delta
	img.global_rotation = body.velocity.angle()
	
