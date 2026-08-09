class_name DarknessHolder

extends Sprite2D

@export var range : float
@export var movable : BaseBody

func _ready() -> void:
	self.modulate.a = 0.0
	await get_tree().process_frame
	self.get_parent().remove_child(self)
	Manager.Player.add_child(self)

func _process(delta: float) -> void:
	if !movable or movable.is_dead:
		self.modulate.a = max(0, self.modulate.a - delta)
		if self.modulate.a <= 0:
			self.queue_free()
		return
	var dist = movable.global_position.distance_to(Manager.Player.global_position)
	var ideal = clamp(1.0 - (dist / range), 0.0, 1.0)
	if self.modulate.a < ideal:
		self.modulate.a = max(ideal, self.modulate.a - delta * 0.3)
	elif self.modulate.a > ideal:
		self.modulate.a = min(ideal, self.modulate.a + delta * 0.3)
	self.global_position = Manager.Player.global_position
