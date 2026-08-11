class_name PassiveEnemyPathfinding

extends HomingPathfinding

@export var maxhealth : int

func _can_see(targetNode : Node2D) -> bool:
	if Movable.HP >= maxhealth:
		return false
	return super._can_see(targetNode)
func _can_target(targetNode : Node2D) -> bool:
	if Movable.HP >= maxhealth:
		return false
	return super._can_target(targetNode)
