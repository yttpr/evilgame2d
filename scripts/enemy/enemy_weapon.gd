class_name EnemyWeapon

extends Node2D

@export var aim_direction : Vector2

@export var weapon : Node2D

@export var bullet : PackedScene
@export var source_name : String

@export var knockback : float
@export var damage_type : String
@export var dmg_amt : int
@export var pierce_amt : int

@export var shot_variance : float

@export var charge_time : float
@export var max_clip : int
@export var shot_delay : float
@export var reload_time : float

@export var move_during_reload : bool
@export var brain : GeneralPathfinding

var target : Node2D
var is_agro : bool

var current_clip : int
var delay_tick : float
var is_reloading : bool
var reload_tick : float
var aiming_tick : float

func _shoot(direction : Vector2) -> void:
	# shoot
	var dir = direction.angle() + randf_range(shot_variance * -1, shot_variance)
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().add_child(proj)
	proj._set_basic_data(dmg_amt, damage_type, knockback)
	proj._set_collision(source_name, Manager.collision_walls, Manager.collision_forEnemy)
	proj.pierce_amt = pierce_amt
	proj.y_change = _get_offset()
	proj._shoot(Vector2.from_angle(dir), self.global_position + _get_offset_vector())
	
	current_clip -= 1
	if current_clip <= 0:
		_set_reload(true)
	else:
		delay_tick = shot_delay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_reload(false)
	_update_color()
	is_agro = false

func _set_agro(unit : Node2D) -> void:
	is_agro = true
	aiming_tick = charge_time
	_set_reload(false)
	target = unit
	_set_aim_dir()

func _set_aim_dir() -> void:
	if !target:
		return
	aim_direction = self.global_position.direction_to(target.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_agro:
		return
	
	#do aiming logic
	if aiming_tick > 0 and visible_aim:
		var dir = aim_direction
		if !stop_looking_while_aiming:
			dir = self.global_position.direction_to(target.global_position).normalized()
		_next_line(true, line_length, delta, self.global_position, self.global_position + dir * line_length, [])
	
	if aiming_tick > 0 and break_aim_if_lost:
		if !_can_see(target):
			is_agro = false
			return
	
	if !stop_looking_while_aiming:
		if !stop_looking_after_charge or aiming_tick > 0:
			_set_aim_dir()
	
	#shoot
	if aiming_tick <= 0 and delay_tick <= 0 and !is_reloading:
		_shoot(aim_direction)
	
	if aiming_tick > 0:
		aiming_tick -= delta
	if delay_tick > 0:
		delay_tick -= delta
	if is_reloading:
		reload_tick -= delta
		if reload_tick <= 0:
			_set_reload(false)


func _get_offset() -> float:
	return weapon.position.y
func _get_offset_vector() -> Vector2:
	return Vector2(0, _get_offset())


#reloading
func _set_reload(reloading : bool) -> void:
	if reloading:
		is_reloading = true
		reload_tick = reload_time
	else:
		is_reloading = false
		current_clip = max_clip
		delay_tick = 0.0
		if !target or !_can_see(target):
			is_agro = false
		_set_aim_dir()
		aiming_tick = charge_time
	if move_during_reload and brain:
		brain._set_moving(reloading)
func _update_color() -> void:
	if damage_type == "Sin":
		aim_color = Manager.sin_color
	elif damage_type == "Cos":
		aim_color = Manager.cos_color


#aiming stuff
@export var break_aim_if_lost : bool
@export var visible_aim : bool
@export var stop_looking_while_aiming : bool
@export var stop_looking_after_charge : bool
@export var aim_color : Color
@export var max_aim_width : float
@export var does_bounce : bool
@export var line_length : float

func _next_line(aiming : bool, length : float, delta : float, origin: Vector2, target_point : Vector2, exclude : Array[RID]) -> Vector2:
	
	#var tarjet = _set_vector_magnitude(target_point, origin, length)
	#make query
	var query = PhysicsRayQueryParameters2D.create(origin, target_point, Manager.collision_walls.collision_mask, exclude)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		
		#result.position -= _get_offset_vector()
		
		if aiming:
			_draw_line(delta, aim_color, max_aim_width * (1 - (aiming_tick / charge_time)), origin, result.position)
		
		# get bounce vector
		var orig = result.position - origin
		length -= orig.length()
		if length <= 0 or result.normal == Vector2.ZERO or !does_bounce:
			return result.position
		
		var aim = orig.bounce(result.normal)
		var finish = _set_vector_magnitude(aim, Vector2.ZERO, length)
		
		return _next_line(aiming, length, delta, result.position + finish.normalized(), result.position + finish, [])
	
	if aiming:
		_draw_line(delta, aim_color, max_aim_width * (1 - (aiming_tick / charge_time)), origin, target_point)
	
	return target_point

func _draw_line(time: float, color : Color, width : float, orig : Vector2, pos : Vector2) -> void:
	if pos.y > orig.y:
		var temp = pos
		pos = orig
		orig = temp
	
	var line = Line2D.new()
	Manager._get_world().add_child(line)
	line.global_position = orig
	line.global_rotation = 0
	#line.position = self.position
	line.add_point(Vector2.ZERO + _get_offset_vector())
	line.add_point(pos - line.global_position + _get_offset_vector())
	line.width = width
	line.modulate = color
	line.material = Manager._tracer_mat()
	line.y_sort_enabled = true
	line.show_behind_parent = true
	
	get_tree().create_timer(time * 2).timeout.connect(line.queue_free)
	#line.queue_free()

func _set_vector_magnitude(vector : Vector2, origin : Vector2, length : float) -> Vector2:
	return origin.direction_to(vector) * length


func _can_see(targetNode : Node2D) -> bool:
	var query = PhysicsRayQueryParameters2D.create(self.global_position, targetNode.global_position, Manager.collision_walls.collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		return result.collider == targetNode
	return true
