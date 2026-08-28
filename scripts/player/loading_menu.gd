class_name LoadingMenu

extends Node2D

@export var bar : Control
@export var bar_length : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bar.scale.x = 0.0

func _update_bar(val : float) -> void:
	if val > 1.0:
		val = 1.0
	bar.scale.x = val * bar_length

var prepped : bool = false
func _process(delta: float) -> void:
	if prepped:
		return
	
	if Manager.Camera:
		Manager.Camera.add_child(self)
		prepped = true
		self.position = Vector2.ZERO
		return
	
	if Manager.Player and Manager.Player.camera:
		Manager.Player.camera.add_child(self)
		prepped = true
		self.position = Vector2.ZERO
		return
