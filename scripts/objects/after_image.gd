class_name AfterImage

extends Sprite2D

@export var lifetime : float

func _copy_info(img : Sprite2D) -> void:
	self.texture = img.texture
	self.hframes = img.hframes
	self.frame = img.frame
	self.offset = img.offset
	self.global_position = img.global_position
	self.z_index = img.z_index
	self.modulate = img.modulate

func _set_lifetime(time : float) -> void:
	lifetime = time
	var down = get_tree().create_tween()
	down.set_ease(Tween.EASE_IN)
	down.set_trans(Tween.TRANS_SINE)
	down.tween_property(self, "modulate", Color(1, 1, 1, 0), lifetime)
	down.tween_callback(queue_free)
