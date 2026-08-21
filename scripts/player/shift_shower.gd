class_name ShiftShower

extends Node2D

func _ready() -> void:
	self.visible = false


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_SHIFT:
		if event.is_pressed():
			self.visible = true
		else:
			self.visible = false
