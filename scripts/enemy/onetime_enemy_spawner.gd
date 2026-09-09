class_name SingleTimeEnemySpawner

extends Node2D

@export var save_name : String
@export var enemy : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Manager._check_run_bool(save_name):
		return
	Manager._set_run_bool(save_name, true)
	await get_tree().process_frame
	_spawn_enemy(enemy)


func _spawn_enemy(reference : PackedScene) -> BaseBody:
	var enemy : BaseBody = reference.instantiate()
	enemy.global_position = self.global_position
	Manager._get_world().add_child(enemy)
	return enemy
