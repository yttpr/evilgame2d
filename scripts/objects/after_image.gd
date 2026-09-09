class_name AfterImage

extends Sprite2D

@export var lifetime : float

func _copy_info(img : Sprite2D) -> void:
	self.texture = img.texture
	self.hframes = img.hframes
	self.frame = img.frame
	self.position = img.offset
	#self.global_position = img.global_position
	self.rotation = img.rotation
	self.z_index = img.z_index
	self.modulate = img.modulate
	self.material = img.material

func _set_lifetime(time : float, node : Node2D = self) -> void:
	lifetime = time
	var down = get_tree().create_tween()
	down.set_ease(Tween.EASE_IN)
	down.set_trans(Tween.TRANS_SINE)
	var fade = Color(self.modulate)
	fade.a = 0.0
	down.tween_property(self, "modulate", fade, lifetime)
	down.tween_callback(node.queue_free)
