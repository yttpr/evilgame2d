class_name ShootAlertPathfinding

extends HomingPathfinding

var has_heard : bool

@export var alert_image : Sprite2D
@export var alert_sound : AudioStream
@export var alert_mod : float
@export var alert_player : BasicAudio

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



func _process(delta: float) -> void:
	if has_heard:
		if !alert_player.playing:
			alert_player._play_sound(alert_sound, alert_mod)
		alert_image.visible = true
	else:
		alert_image.visible = false
		alert_player.stop()
	
	super._process(delta)
