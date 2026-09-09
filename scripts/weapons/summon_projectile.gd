class_name SummonProjectile

extends BasicProjectile

@export var bullet : PackedScene
@export var img : Sprite2D
@export var shoot_from : Node2D
@export var interval : float
var tick : float

@export var start_delay : float = 1.0

@export var source_mod : String = "abcdefghijklmnopqrstuvwxyz"
var source_index : int

@export var shoot_cycle : bool
@export var rotate_rate : float
@export var start_angle : float = 90.0
var rotate_id : float

var start_tick : float

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	source_index = randi_range(0, source_mod.length() - 1)
	self.global_position = origin
	img.position.y = y_change
	img.modulate = tracer_color
	tick = interval
	start_tick = start_delay
	rotate_id = deg_to_rad(start_angle)
	_go_up()

@export var visible_start_aim : bool
@export var line_length : float = 2000.0
@export var max_aim_width : float = 2.0
func _process(delta : float) -> void:
	super._process(delta)
	if start_tick > 0:
		start_tick -= delta
		if visible_start_aim and delta > 0:
			var dir = Vector2.from_angle(rotate_id)
			_next_line(true, line_length, delta, self.global_position, self.global_position + dir * line_length, [])
	
	
	if shoot_cycle and start_tick <= 0:
		rotate_id += rotate_rate * delta
	
	if tick > 0:
		tick -= delta
		if tick <= 0:
			tick = interval
			if start_tick > 0:
				return
			
			if shoot_cycle:
				_shoot_buddy(Vector2.from_angle(rotate_id))
				return
			
			_update_nearest()
			if nearest:
				_shoot_buddy(self.global_position.direction_to(nearest.global_position))


var targets : Array[BaseBody]
var nearest : BaseBody

func _on_body_entered(body : Node2D) -> void:
	if !targets:
		targets = []
	if body is BaseBody:
		var unit : BaseBody = body
		targets.append(unit)
func _on_body_exited(body : Node2D) -> void:
	if targets and body is BaseBody:
		var unit : BaseBody = body
		targets.erase(unit)

func _update_nearest() -> void:
	nearest = null
	if !targets or targets.size() <= 0:
		return
	
	var dist : float = INF
	for obj in targets:
		if !_can_target(obj):
			continue
		var lent = self.global_position.distance_to(obj.global_position)
		if lent < dist:
			dist = lent
			nearest = obj

func _can_target(targetNode : Node2D) -> bool:
	var query = PhysicsRayQueryParameters2D.create(self.global_position, targetNode.global_position, Manager.collision_walls.collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		return result.collider == targetNode
	return true

@export var pass_through_walls : bool
func _shoot_buddy(dir : Vector2) -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().add_child(proj)
	proj.death_quote.assign(death_quote)
	proj.source = source + "_" + source_mod[source_index]
	source_index += 1
	if source_index >= source_mod.length():
		source_index = 0
	proj.visible = true
	proj._set_basic_data(dmg, type, knockback_mod)
	var wall_detect = bouncer
	if pass_through_walls:
		wall_detect = Manager.collision_nothing
	proj._set_collision(proj.source, wall_detect, damager)
	proj.y_change = img.position.y
	proj._shoot(dir, shoot_from.global_position)

@export var hover_time : float = 1.5
@export var hover_dist : float = -20.0
func _go_up() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(img, "position", Vector2(0, y_change + hover_dist), hover_time)
	tween.tween_callback(_go_down)

func _go_down() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(img, "position", Vector2(0, y_change), hover_time)
	tween.tween_callback(_go_up)


func _next_line(aiming : bool, length : float, delta : float, origin: Vector2, target_point : Vector2, exclude : Array[RID]) -> Vector2:
	
	var draw_color = Color(tracer_color)
	draw_color.a = 0.7
	#var tarjet = _set_vector_magnitude(target_point, origin, length)
	#make query
	var mask = bouncer.collision_mask
	if pass_through_walls:
		mask = Manager.collision_nothing.collision_mask
	var query = PhysicsRayQueryParameters2D.create(origin, target_point, mask, exclude)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		
		#result.position -= _get_offset_vector()
		
		if aiming:
			_draw_line(delta, draw_color, max_aim_width * (1 - (start_tick / start_delay)), origin, result.position)
		
		# get bounce vector
		var orig = result.position - origin
		length -= orig.length()
		if length <= 0 or result.normal == Vector2.ZERO:
			return result.position
		
		var aim = orig.bounce(result.normal)
		var finish = _set_vector_magnitude(aim, Vector2.ZERO, length)
		
		return _next_line(aiming, length, delta, result.position + finish.normalized(), result.position + finish, [])
	
	if aiming:
		_draw_line(delta, draw_color, max_aim_width * (1 - (start_tick / start_delay)), origin, target_point)
	
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
	line.add_point(Vector2.ZERO + img.position)
	line.add_point(pos - line.global_position + img.position)
	line.width = width
	line.modulate = color
	line.material = Manager._tracer_mat()
	line.y_sort_enabled = true
	line.show_behind_parent = true
	if pass_through_walls:
		line.z_index = 2
	
	get_tree().create_timer(time * 2).timeout.connect(line.queue_free)
	#line.queue_free()
func _set_vector_magnitude(vector : Vector2, origin : Vector2, length : float) -> Vector2:
	return origin.direction_to(vector) * length
