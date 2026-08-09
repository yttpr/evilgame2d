class_name GeneralPathfinding

extends Node2D

@export var Movable : BaseBody
@export var Looking : Node2D
@export var Weapon : EnemyWeapon

var speed: float = 100.0
@export var nav_agent: NavigationAgent2D


@export var process_tick = 60
var tick : int = 0

var Follow_Target : Node2D
var require_see : bool

var did_see : bool
var follow_seen : Vector2

var turn_speed = 0.01

var can_move : bool

func _set_moving(field : bool) -> void:
	can_move = field

func _set_follow(field : Node2D, need_see := false) -> void:
	var old = Follow_Target
	Follow_Target = field
	require_see = need_see
	did_see = false
	tick = process_tick
	if Follow_Target != old:
		_set_target(Vector2(Follow_Target.global_position))

func _ready() -> void:
	speed = Movable.mov_spd * randf_range(0.85, 1.15)
	can_move = true
	# Wait for the navigation map to be ready
	await get_tree().physics_frame
	if !Manager.world:
		await get_tree().process_frame
	Manager._get_world().Enemies.append(Movable)

	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	nav_agent.max_speed = speed

func _process(delta: float) -> void:
	if Movable.is_dead:
		Weapon.is_agro = false
		Weapon.process_mode = Node.PROCESS_MODE_DISABLED
		Movable.velocity = Vector2.ZERO
		return
	
	if !Follow_Target:
		return
	tick += 1
	if tick > process_tick:
		tick = 0
		if require_see:
			if _can_see(Follow_Target):
				follow_seen = Vector2(Follow_Target.global_position)
				did_see = true
				_set_target(follow_seen)
			elif did_see:
				_set_target(follow_seen)
				# create some abort target method
			else:
				Follow_Target = null
		else:
			_set_target(Vector2(Follow_Target.global_position))
	

func _can_see(targetNode : Node2D) -> bool:
	var query = PhysicsRayQueryParameters2D.create(Movable.global_position, targetNode.global_position, Manager.collision_sight.collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		return result.collider == targetNode
	return true
func _can_target(targetNode : Node2D) -> bool:
	var query = PhysicsRayQueryParameters2D.create(Movable.global_position, targetNode.global_position, Manager.collision_walls.collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		return result.collider == targetNode
	return true



func _to_target(targetNode : Node2D) -> float:
	return Movable.global_position.distance_to(targetNode.global_position)

func _set_target(target_pos: Vector2) -> void:
	if nav_agent.target_position == target_pos:
		return
	nav_agent.target_position = target_pos

func _at_target() -> bool:
	return nav_agent.is_navigation_finished()

func _physics_process(delta: float) -> void:
	if Movable.is_dead:
		Weapon.is_agro = false
		Movable.velocity = Vector2.ZERO
		return
	
	if !can_move:
		Movable.velocity = Vector2.ZERO
		return
	
	if nav_agent.is_navigation_finished():
		Movable.velocity = Vector2.ZERO
		return

	var next_pos := nav_agent.get_next_path_position()
	var direction := Movable.global_position.direction_to(next_pos)
	if Looking:
		if Follow_Target and !require_see:
			SmoothLookAt(Looking, Follow_Target.global_position, turn_speed / delta)
		else:
			SmoothLookAt(Looking, next_pos, turn_speed / delta)
	
	if nav_agent.avoidance_enabled:
		var intended_velocity = direction * _get_speed()
		nav_agent.set_velocity(intended_velocity)
	else:
		Movable.velocity = direction * _get_speed()
		#Movable._make_movement()

func _get_speed() -> float:
	return speed


#looking scripts
func SmoothLookAt( nodeToTurn, targetPosition, turnSpeed ):
	nodeToTurn.rotate(deg_to_rad(AngularLookAt(nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed)))
func AngularLookAt( currentPosition, currentRotation, targetPosition, turnTime ):
	return GetAngle(currentRotation, TargetAngle(currentPosition, targetPosition))/turnTime
func TargetAngle( currentPosition, targetPosition ):
	return (targetPosition - currentPosition).angle()
func GetAngle( currentAngle, targetAngle ):
	return fposmod( targetAngle - currentAngle + PI, PI * 2 ) - PI


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if !can_move:
		return
		
	Movable.velocity = safe_velocity
	#Movable._make_movement()


func _wander() -> void:
	if Weapon:
		Weapon.is_agro = false
	Follow_Target = null
	#print("should wander..")
	_set_target(NavigationServer2D.map_get_random_point(get_world_2d().get_navigation_map(), nav_agent.navigation_layers, true))
