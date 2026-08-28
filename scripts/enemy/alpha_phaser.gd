class_name AlphaPhaser

extends Node2D

@export var image : Node2D
@export var time : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_go_down()

func _go_up() -> void:
	var tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(image, "modulate", Color(1, 1, 1, 1), time)
	tween.tween_callback(_go_down)

func _go_down() -> void:
	var tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(image, "modulate", Color(1, 1, 1, 0), time)
	tween.tween_callback(_go_up)
