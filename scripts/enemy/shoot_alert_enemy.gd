class_name ShootAlertPathfinding

extends HomingPathfinding

var has_heard : bool

func _wander() -> void:
	super._wander()
	has_heard = false


func _can_see(targetNode : Node2D) -> bool:
	if !has_heard:
		return false
	return super._can_see(targetNode)
func _can_target(targetNode : Node2D) -> bool:
	if !has_heard:
		return false
	return super._can_target(targetNode)


func _unique_can_see(targetNode : Node2D) -> bool:
	var query = PhysicsRayQueryParameters2D.create(Movable.global_position, targetNode.global_position, Manager.collision_sight.collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		return result.collider == targetNode
	return true
