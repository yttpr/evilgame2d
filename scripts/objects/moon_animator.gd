extends Node2D

@export var dist : float = 16
@export var time : float = 5

@export var random_delay : bool

var source : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	source = self.global_position
	if random_delay:
		await get_tree().create_timer(randf_range(0, time * 2)).timeout
	_go_up()

func _go_up() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", source + Vector2(dist, 0), time)
	tween.tween_callback(_go_down)

func _go_down() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", source + Vector2(dist * -1, 0), time)
	tween.tween_callback(_go_up)
