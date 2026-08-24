class_name EnemySpawner

extends Node2D

@export var range_from_player : float = 1000
@export var spawn_cap : int = 8

@export var data : EnemySpawnList

@export var spawn_time : float = 20
var spawn_tick : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_tick = randf_range(0, spawn_time / 2)
	await get_tree().process_frame
	if Manager.world:
		Manager._get_world().EnemySpawnLocs.append(self)

func _get_id() -> int:
	var top = 0
	for weight in data.Weights:
		top += weight
	var num = randi_range(0, top - 1)
	var current = 0
	for i in data.Weights.size():
		current += data.Weights[i]
		if num < current:
			return i
	return 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_tick -= delta
	if spawn_tick <= 0:
		spawn_tick = spawn_time
		if _can_spawn():
			_spawn_enemy(_get_random_enemy_data())


func _can_spawn() -> bool:
	if self.global_position.distance_to(Manager.Player.global_position) < range_from_player:
		return false
	if Manager._get_world().Enemies.size() >= spawn_cap:
		return false
	return true

func _get_random_enemy_data() -> PackedScene:
	return data.Enemies[_get_id()]

func _spawn_enemy(reference : PackedScene) -> BaseBody:
	var enemy : BaseBody = reference.instantiate()
	enemy.global_position = self.global_position
	Manager._get_world().add_child(enemy)
	return enemy
