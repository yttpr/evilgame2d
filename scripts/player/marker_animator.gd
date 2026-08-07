extends Node2D

@export var marker : Sprite2D
@export var max : float
@export var time : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_go_up()

func _go_up() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(marker, "position", Vector2(0, max), time)
	tween.tween_callback(_go_down)

func _go_down() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(marker, "position", Vector2.ZERO, time)
	tween.tween_callback(_go_up)
