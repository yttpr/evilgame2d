extends Node2D

@export var label : Label
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(min(999, Manager.coins))
