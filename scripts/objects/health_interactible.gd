class_name HealthInteractible

extends BaseInteractible

@export var killed_id : String
@export var body : BaseDestructible
@export var sound : AudioStream
@export var audio_mod : float

@export var coin_cost : int
@export var label : Label

func _ready() -> void:
	_hide_dialogue()
	label.visible = false
	super._ready()
	if Manager._check_run_bool(killed_id):
		body.skip_gibs = true
		body._destroy()

func _run() -> void:
	if body.destroyed:
		return
	if Manager.current_hp >= Manager.current_chara.HP:
		Manager._play_oneshot(self.global_position, Manager.ui_fail, 20)
		dialogue = "Already at full health!"
		_show_dialogue()
		return
	if Manager.coins < coin_cost:
		Manager._play_oneshot(self.global_position, Manager.ui_fail, 20)
		dialogue = "Not enough coins!"
		_show_dialogue()
		return
	if coin_cost > 0:
		Manager.coins -= coin_cost
	
	Manager.current_hp += 1
	Manager.Player.HP += 1
	Manager.Player.ui.Health._set_current_health(Manager.current_hp)
	Manager._play_oneshot(self.global_position, sound, audio_mod)

func _on_nearest() -> void:
	if body.destroyed:
		return
	if tween:
		tween.kill()
	if coin_cost > 0:
		label.text = str(coin_cost) + " Coins"
		label.visible = true
		label.modulate = Color.WHITE
	else:
		label.visible = false

var tween : Tween
@export var label_off_time : float
func _leave_nearest() -> void:
	if label.visible:
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(label, "modulate", Color(1, 1, 1, 0), label_off_time)
		tween.tween_callback(_hide_label)

func _hide_label() -> void:
	label.visible = false
	label.modulate = Color.WHITE


func _process(delta : float) -> void:
	super._process(delta)
	if body.destroyed:
		Manager._set_run_bool(killed_id, true)
		self.remove_child(body)
		Manager._get_world().add_child(body)
		body.global_position = self.global_position
		self.queue_free()



@export var talker : Label
var dialogue : String
@export var talk_time : float

func _hide_dialogue() -> void:
	talker.visible = false

var talk_tween : Tween
func _show_dialogue() -> void:
	if talk_tween:
		talk_tween.kill()
	talker.visible = true
	talker.modulate = Color.WHITE
	talker.text = dialogue
	talk_tween = get_tree().create_tween()
	talk_tween.set_ease(Tween.EASE_IN)
	talk_tween.set_trans(Tween.TRANS_SINE)
	talk_tween.tween_property(talker, "modulate", Color(1, 1, 1, 0), talk_time)
	talk_tween.tween_callback(_hide_dialogue)
