class_name BaseDestructible

extends StaticBody2D

@export var HP : int = 10

@export var image : Sprite2D

@export var gibs : GibData

var destroyed : bool
var ticks : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destroyed = false
	enable_collision(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ticks -= 1
	if ticks <= 0:
		image.offset = Vector2.ZERO
	_process_i_frames(delta)

var inertia : Vector2
func _get_hit(amt : int, type : String, source : String, mov : Vector2, extra : bool = false) -> bool:
		if HP >= 999:
			return false
		if source.contains("Power"):
			amt *= 10
		if !_check_i_frame(source):
			return false
		Manager._make_damage_popup(amt, self.global_position, type == "Sin")
		if destroyed:
			return false
		HP -= amt
		if HP > 0:
			image.offset = Vector2.from_angle(randf_range(0.0, -1 * PI)) * 2.5
			ticks = 6
			return true
		inertia = mov
		_destroy()
		return true

@export var i_frame_time : float = 0.05
var i_frames : Dictionary
func _check_i_frame(source : String) -> bool:
	if source.contains("0"):
		return true
	if !i_frames:
		i_frames = {}
	
	if !i_frames.has(source):
		i_frames.set(source, i_frame_time)
	elif i_frames[source] > 0:
		return false
	
	return true
func _process_i_frames(delta : float) -> void:
	if !i_frames:
		return
	var keys = i_frames.keys()
	for key in keys:
		i_frames[key] = i_frames[key] - delta
		if i_frames[key] <= 0:
			i_frames.erase(key)

func _destroy() -> void:
	destroyed = true
	enable_collision(false)
	var tween = get_tree().create_tween()
	tween.tween_property(image, "scale", Vector2.ONE * 1.01, 0.05)
	tween.tween_callback(_clean)

var skip_gibs : bool
func _clean() -> void:
	image.visible = false
	if gibs and !skip_gibs:
		Manager._make_gibs(self.global_position, inertia / 10, gibs)

func enable_collision(enable : bool):
	$CollisionShape2D.set_deferred("disabled", !enable)
	
	$NavigationRegion2D.enabled = !enable
	
	#if !enable:
		#NavigationServer2D.region_set_map($NavigationRegion2D, get_world_2d().get_navigation_map())
		#NavigationServer2D.region_set_enabled($NavigationRegion2D, !enable)
