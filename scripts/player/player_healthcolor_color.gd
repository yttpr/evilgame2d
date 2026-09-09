class_name HealthColorImage

extends Sprite2D

@export var body : BaseBody



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if body.healthtype == "Sin":
		self.modulate = Manager.sin_color
	elif body.healthtype == "Cos":
		self.modulate = Manager.cos_color
