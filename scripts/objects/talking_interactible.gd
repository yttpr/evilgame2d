class_name TalkingInteractible

extends BaseInteractible

func _ready() -> void:
	label.visible = false

@export var label : Label
@export var dialogue : Array[String]
@export var talk_time : float

func _hide_dialogue() -> void:
	label.visible = false

var tween : Tween
func _show_dialogue() -> void:
	if tween:
		tween.kill()
	label.visible = true
	label.modulate = Color.WHITE
	label.text = dialogue[randi_range(0, dialogue.size() - 1)]
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(label, "modulate", Color(1, 1, 1, 0), talk_time)
	tween.tween_callback(_hide_dialogue)

func _run() -> void:
	_show_dialogue()
