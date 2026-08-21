class_name DecayEnemyBody

extends BaseBody

@export var enemydata : PackedScene
func _spawn() -> void:
	if !enemydata:
		return
	var enemy : BaseBody = enemydata.instantiate()
	Manager._get_world().add_child(enemy)
	enemy.universal_i_frames = 0.15
	enemy.global_position = self.global_position
	if spawn_amt > 1:
		enemy.global_position += Vector2.from_angle(randf_range(0.0, 2*PI)) * randf_range(2.0, 6.0)

@export var spawn_amt : int

func _on_die() -> void:
	for i in spawn_amt:
		_spawn()
	super._on_die()
