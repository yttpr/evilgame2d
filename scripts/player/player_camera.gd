class_name PlayerCamera

extends Camera2D

@export var decay : float = 0.8 # Time it takes to reach 0% of trauma
@export var max_offset : Vector2 = Vector2(100, 75) # Max hor/ver shake in pixels
@export var max_roll : float = 0.1 # Maximum rotation in radians (use sparingly)
@export var follow_node : Node2D # Node to follow (assign this to your player)

@export var cam_speed : float = 3
@export var ui_offset : Vector2
@export var ui : PlayerStatsDisplay

var trauma : float = 0.0 # Current shake strength
var trauma_power : int = 2 # Trauma exponent. Increase for more extreme shaking

var decay_time_mod : float
var current_position : Vector2
var tick_wait = 0

func _ready() -> void:
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	tick_wait = 10
	Manager.Camera = self
	if Manager.current_zoom < 0:
		zoom.x = 1.1
		zoom.y = 1.1
		Manager.current_zoom = 1.1
	else:
		zoom.x = Manager.current_zoom
		zoom.y = Manager.current_zoom
	_update_ui()
	#? Randomize the game seed
	randomize()
	current_position = global_position

func _input(event):
	if Manager.is_paused or Manager.lock_input:
		return
	if Manager.Player and Manager.Player.is_dead:
		return
	
	if event is InputEventKey and event.pressed:
		#zoom in
		if event.keycode == KEY_EQUAL or event.keycode == KEY_E:
			_zoom(1)
		# zoom out
		if event.keycode == KEY_MINUS or event.keycode == KEY_Q:
			_zoom(-1)

func _process(delta : float) -> void:
	if tick_wait > 0:
		tick_wait -= 1
		return
	if follow_node: # If the follow node exists
		#direction
		var distance = follow_node.global_position - current_position
		current_position += distance * cam_speed * delta #* (delta / Player._get_slowest_time())
		global_position = current_position
		
	else:
		global_position = Vector2(500, 275)
	if trauma: # If the camera is currently shaking
		trauma = max(trauma - decay * pow(1 / decay_time_mod, 0.35) * delta, 0) # Decay the shake strength
		shake() # Shake the camera
	
	var screen_pos = Vector2(575, 275)
	screen_pos = Manager.Player.get_global_transform_with_canvas().get_origin()
	#screen_pos = screen_pos
	screen_pos += Vector2(0, -50)
	#var thex = get_tree().root.content_scale_size.x / 1152
	#var they = get_tree().root.content_scale_size.y / 648
	#screen_pos.x *= thex
	#screen_pos.y *= they
	#screen_pos = Vector2(get_tree().root.content_scale_size.x / 2, get_tree().root.content_scale_size.y / 2)
	#print(RenderingServer.global_shader_parameter_get("PlayerLoc"))
	RenderingServer.global_shader_parameter_set("PlayerLoc", screen_pos)

## The function to use for adding trauma (screen shake)
func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0) # Add the amount of trauma (capped at 1.0)

## This function is used to actually apply the shake to the camera
func shake() -> void:
	#? Set the camera's rotation and offset based on the shake strength
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)


func _set_vector_magnitude(vector : Vector2, origin : Vector2, length : float) -> Vector2:
	return origin.direction_to(vector) * length

@export var debug : bool
# zoom stuff
func _zoom(mod : float) -> void:
	mod *= 0.1
	var minm = 0.7
	if debug:
		minm = 0.1
	zoom.x = clamp(zoom.x + mod, minm, 1.5)
	zoom.y = clamp(zoom.y + mod, minm, 1.5)
	Manager.current_zoom = zoom.x
	
	_update_ui()

func _update_ui() -> void:
	ui.position = ui_offset / zoom.x
	ui.scale = Vector2.ONE / zoom.x
