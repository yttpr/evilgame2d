class_name FrameCopy

extends Sprite2D

@export var source : Sprite2D


func _ready() -> void:
	self.visible = false
	hframes = source.hframes
	offset = source.offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	texture = source.texture
	frame = source.frame
	flip_h = source.flip_h
	flip_v = source.flip_v


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_SHIFT:
		if event.is_pressed():
			self.visible = true
		else:
			self.visible = false
