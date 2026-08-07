class_name EnemyDoorInteractible

extends DoorInteractible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Manager.world:
		locked = Manager._get_world().Enemies.size() > 0
