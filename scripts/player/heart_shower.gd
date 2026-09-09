class_name HeartShower

extends ShiftShower

var should_show : bool

func _ready() -> void:
	should_show = false
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#return
	if Manager.Player and Manager.Player.is_dead:
		self.visible = false
		return
	should_show = Manager.show_hitboxes
	#print(should_show)
	if should_show or (Manager._get_world() and Manager._get_world().Bosses.size() > 0):
		self.visible = true
	else:
		self.visible = false

func _input(event: InputEvent) -> void:
	return
	if Manager.Player and Manager.Player.is_dead:
		return
	if event is InputEventKey and event.keycode == KEY_SHIFT:
		if event.is_pressed():
			should_show = !should_show
		#else:
			#should_show = false
