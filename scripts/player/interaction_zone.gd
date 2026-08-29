class_name InteractionZone

extends Area2D

@export var indicator : Node2D
var in_range : Array[BaseInteractible]
var nearest : BaseInteractible


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	in_range = []

func _input(event: InputEvent) -> void:
	if Manager.is_paused or Manager.lock_input:
		return
	if Manager.Player.is_dead:
		return
	if !nearest:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			nearest._run()
			#if nearest and !nearest.can_interact:
			#	in_range.erase(nearest)
			_update_nearest()

var ticks : int
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ticks -= 1
	if ticks <= 0:
		ticks = 15
		_update_nearest()
	
	if nearest != null and !nearest.has_self_marker:
		indicator.visible = true
		indicator.global_position = nearest.global_position + nearest.marker_offset
	else:
		indicator.visible = false

func _on_body_entered(node : Node2D) -> void:
	if node is BaseInteractible:
		var body : BaseInteractible = node
		in_range.append(body)
		_update_nearest()
func _on_body_exited(node : Node2D) -> void:
	if node is BaseInteractible:
		var body : BaseInteractible = node
		if node == nearest:
			node._leave_nearest()
		in_range.erase(body)
		_update_nearest()

func _update_nearest() -> void:
	if in_range.size() <= 0:
		nearest = null
		return
	
	var old = nearest
	
	var dist : float = INF
	for obj in in_range:
		if !obj.can_interact:
			continue
		var lent = self.global_position.distance_to(obj.global_position)
		if lent < dist:
			dist = lent
			nearest = obj
	
	if old == nearest:
		return
	nearest._on_nearest()
	if old:
		old._leave_nearest()
