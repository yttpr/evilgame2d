class_name ShotgunProjectile

extends MovingProjectile

@export var shoot_range : float
@export var amount : int

@export var original = true

func _ready() -> void:
	if abs(shoot_range) > PI*2:
		shoot_range = deg_to_rad(shoot_range)


func _shoot(direction : Vector2, origin : Vector2) -> void:
	if !original:
		super._shoot(direction, origin)
		return
	#self.collider.collider.disabled = true
	self.visible = false
	
	var base_angle = direction.angle() - (shoot_range / 2)
	var split = shoot_range / (amount - 1)
	
	for i in amount:
		var copy : ShotgunProjectile = self.duplicate()
		copy.visible = true
		copy.original = false
		self.get_parent().add_child(copy)
		copy._shoot(Vector2.from_angle(base_angle + split * i), origin)
		
		#await get_tree().create_timer(interval).timeout
	self.queue_free()


func _process(delta: float) -> void:
	if original:
		return
	super._process(delta)
