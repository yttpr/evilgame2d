class_name SummonProjectile

extends BasicProjectile

@export var bullet : PackedScene
@export var img : Sprite2D
@export var shoot_from : Node2D
@export var interval : float
var tick : float

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	self.global_position = origin
	img.position.y = y_change
	img.modulate = tracer_color
	tick = 1
	_go_up()

func _process(delta : float) -> void:
	super._process(delta)
	
	if tick > 0:
		tick -= delta
		if tick <= 0:
			tick = interval
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
	if targets.size() <= 0:
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


func _shoot_buddy(dir : Vector2) -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().add_child(proj)
	proj.death_quote.assign(death_quote)
	proj.visible = true
	proj._set_basic_data(dmg, type, knockback_mod)
	proj._set_collision(source, bouncer, damager)
	proj.y_change = y_change
	proj._shoot(dir, shoot_from.global_position)


func _go_up() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(img, "position", Vector2(0, y_change + 10), 1.5)
	tween.tween_callback(_go_down)

func _go_down() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(img, "position", Vector2(0, y_change), 1.5)
	tween.tween_callback(_go_up)
