class_name CirclingProjectile

extends MovingProjectile

@export var max_rot : float
var rot : float
@export var max_spd : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rot_spd = randf_range(0, rot_spd * 2)
	if randf_range(0.0, 1.0) < 0.5:
		rot_spd *= -1
	spd = randf_range(spd, max_spd)
	rot = randf_range(0, max_rot)
	if randf_range(0.0, 1.0) < 0.5:
		rot *= -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	var length = body.velocity.length()
	var dir = body.velocity.angle()
	
	body.velocity = Vector2.from_angle(dir + rot * delta) * length
