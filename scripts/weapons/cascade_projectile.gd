class_name CascadeProjectile

extends MovingProjectile

@export var cascade_amount : int
@export var cascade_mod : float
@export var cascade_time : float
var ready_tick : float

func _process(delta: float) -> void:
	super._process(delta)
	if cascade_amount <= 0:
		return
	ready_tick += delta
	if ready_tick >= cascade_time:
		ready_tick = 0
		cascade_amount -= 1
		var copy : CascadeProjectile = self.duplicate()
		copy._make_the_collider()
		self.get_parent().add_child(copy)
		copy.velocity = self.velocity.length() * Vector2.from_angle(self.velocity.angle() + cascade_mod)
		var dob : CascadeProjectile = self.duplicate()
		dob._make_the_collider()
		self.get_parent().add_child(dob)
		dob.velocity = self.velocity.length() * Vector2.from_angle(self.velocity.angle() - cascade_mod)
		cascade_amount = 0
