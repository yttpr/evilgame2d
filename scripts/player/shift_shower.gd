class_name ShiftShower

extends Node2D

@export var disable_this : bool

func _ready() -> void:
	self.visible = false

func _process(delta: float) -> void:
	if disable_this:
		self.visible = false
		return
	if Manager.Player and Manager.Player.is_dead:
		self.visible = false
		return
	self.visible = Manager.show_hitboxes

func _input(event: InputEvent) -> void:
	return
	if disable_this:
		self.visible = false
		return
	if Manager.Player and Manager.Player.is_dead:
		return
	if event is InputEventKey and event.keycode == KEY_SHIFT:
		if event.is_pressed():
			self.visible = !self.visible
		#else:
			#self.visible = false
