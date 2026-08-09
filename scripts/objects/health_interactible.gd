class_name HealthInteractible

extends BaseInteractible

@export var killed_id : String
@export var body : BaseDestructible
@export var sound : AudioStream
@export var audio_mod : float

@export var coin_cost : int
@export var label : Label

func _ready() -> void:
	label.visible = false
	super._ready()
	if Manager._check_run_bool(killed_id):
		body.skip_gibs = true
		body._destroy()

func _run() -> void:
	if body.destroyed:
		return
	if Manager.coins < coin_cost or Manager.current_hp >= Manager.current_chara.HP:
		Manager._play_oneshot(self.global_position, Manager.ui_fail, 20)
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
