extends Node2D

@export var lights : Array[PointLight2D]
@export var flicker : bool
@export var flicker_chance : float = 0.35
@export var only_near : bool

var is_on : bool

@export var tick_time : float = 10.0
var ticks : float

@export var flicker_on_time : float = 3.0
@export var flicker_off_time : float = 1.0
var flick : float

func _ready() -> void:
	ticks = randf_range(0, tick_time)
	_check_near()
	if flicker:
		flicker = randf_range(0.0, 1.0) < flicker_chance

func _process(delta: float) -> void:
	if is_on and flicker:
		flick -= delta
		if flick <= 0.0:
			_set_lights(!activated)
			if activated:
				flick = randf_range(0.0, flicker_on_time)
			else:
				flick = randf_range(0.0, flicker_off_time)
	if only_near:
		ticks -= delta
		if ticks <= 0.0:
			ticks = tick_time
			_check_near()

var activated : bool
func _set_lights(on : bool) -> void:
	activated = on
	for light in lights:
		light.enabled = on

func _check_near() -> void:
	if !only_near:
		_set_lights(true)
		return
	is_on = self.global_position.distance_to(Manager.Player.global_position) < 850
	_set_lights(is_on)
