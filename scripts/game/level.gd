class_name LevelManager

extends Node2D

@export var is_spawn : bool
@export var canvasmodulate : CanvasModulate
var orig_color : Color

@export var entries : Array[Vector2]

@export var songs : Array[AudioStream]
@export var volumes : Array[float]

@export var Enemies : Array[BaseBody] = []

var ticks : int
var time : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orig_color = canvasmodulate.color
	Manager.world = self
	if !Enemies:
		Enemies = []
	if Manager.Player:
		Music.noise.global_position = entries[Manager.spawn_loc]
		Manager.Player.global_position = entries[Manager.spawn_loc]
		Manager.Player.camera.current_position = Manager.Player.camera.follow_node.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -= delta
	if time <= 0:
		time = 60
		ticks += 1
