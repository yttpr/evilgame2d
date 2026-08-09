class_name CoinGib

extends GibBody

@export var wait_time : float = 1.5
@export var gain_time : float = 1.5
@export var noise : AudioStream

func _ready() -> void:
	Manager.wip_coins += 1
	self.material = Manager.bright_mat

var main_tween : Tween

func _process(delta : float) -> void:
	super._process(delta)
	if collect and Manager._get_world().ticks > collect_at:
		_check_pit()

var collect : bool
var collect_at : int
func _check_pit() -> void:
	collect = true
	collect_at = Manager._get_world().ticks
	await get_tree().create_timer(randf_range(0, wait_time)).timeout
	var pos = self.global_position
	self.get_parent().remove_child(self)
	Manager.Player.ui.add_child(self)
	self.global_position = pos
	self.z_index += 1
	var down = get_tree().create_tween()
	down.set_ease(Tween.EASE_IN)
	down.set_trans(Tween.TRANS_QUAD)
	down.tween_property(self, "position", Manager.Player.ui.Coins.position, gain_time)
	down.parallel().tween_property(self, "scale", Vector2.ONE * 3, gain_time)
	down.tween_callback(_done)
	main_tween = down

func _done() -> void:
	if Manager.Player.is_dead:
		self.queue_free()
		return
	Manager.coins += 1
	Manager.wip_coins -= 1
	var gib = Manager._make_bullet_gib(self.global_position, Vector2.ZERO, self.modulate)
	gib.get_parent().remove_child(gib)
	self.get_parent().add_child(gib)
	gib.position = self.position
	gib.z_index += 1
	gib.scale = self.scale
	Manager._play_oneshot(Manager.Player.global_position, noise, 3)
	self.queue_free()
