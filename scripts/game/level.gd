class_name LevelManager

extends Node2D

@export var is_spawn : bool
@export var canvasmodulate : CanvasModulate
var orig_color : Color

@export var entries : Array[Vector2]

@export var songs : Array[AudioStream]
@export var volumes : Array[float]

@export var Enemies : Array[BaseBody] = []

@export var water_pits : bool

var ticks : int
var time : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Manager.wip_coins and Manager.wip_coins > 0:
		Manager.coins += Manager.wip_coins
		Manager.wip_coins = 0
	orig_color = Color(canvasmodulate.color)
	Manager.world = self
	if !Enemies:
		Enemies = []
	if Manager.Player:
		Music.noise.global_position = entries[Manager.spawn_loc]
		Manager.Player.global_position = entries[Manager.spawn_loc]
		Manager.Player.camera.current_position = Manager.Player.camera.follow_node.global_position
	Music._check()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -= delta
	if time <= 0:
		time = 60
		ticks += 1

var color_tick : float

func _calc_color(delta : float) -> void:
	if !canvasmodulate:
		return
	
	var accel = 0.0
	
	for enemy in Enemies:
		if enemy.cause_darkening:
			accel += max(0, 1 - (Manager.Player.global_position.distance_to(enemy.global_position) / enemy.darkening_range))
	
	var num = canvasmodulate.color.r
	if accel > 10:
		num -= accel * delta
	else:
		num += delta * 0.5
	
	if num < 0.1:
		num = 0.1
	if num > orig_color.r:
		num = orig_color.r
	
	canvasmodulate.color = Color(num, num, num, 1)
