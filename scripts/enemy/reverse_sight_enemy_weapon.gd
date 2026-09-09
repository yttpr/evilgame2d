class_name ReverseSightEnemyWeapon

extends EnemyWeapon

func _can_see(targetNode : Node2D) -> bool:
	return !super._can_see(targetNode)
