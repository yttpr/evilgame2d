class_name DamageCollider

extends Area2D

@export var projectile : BasicProjectile
@export var collider : CollisionShape2D
@export var exclude_extra : bool
@export var check_line_walls : bool

@export var damage_type : String
@export var damage_amt : int
@export var damage_source : String
@export var inertia : Vector2
@export var pierce : float

@export var duration : float
@export var radial_knockback : bool = false

@export var death_quote : Array[String]

var frame_buffer : int = 0
var lifetime : bool

func _detail(amt : int, type : String, source : String, mov : Vector2) -> void:
	damage_amt = amt
	damage_type = type
	damage_source = source
	inertia = mov
func _set_duration(has_time : bool, time : float) -> void:
	duration = time
	lifetime = has_time
func _set_pierce(val : int) -> void:
	pierce = val

func _make_collider() -> void:
	var col = CollisionShape2D.new()
	self.add_child(col)
	collider = col
func _set_circle(radius : float) -> void:
	collider.shape = CircleShape2D.new()
	collider.shape.radius = radius
func _set_line(first : Vector2, second : Vector2) -> void:
	collider.shape = SegmentShape2D.new()
	collider.shape.a = first
	collider.shape.b = second

func _set_parent(newparent : Node2D) -> void:
	newparent.add_child(self)
	self.position = Vector2.ZERO
func _set_to_world() -> void:
	Manager._get_world().add_child(self)
	self.global_position = Vector2.ZERO

func _set_collision(body : CollisionObject2D) -> void:
	self.collision_mask = body.collision_mask

func _process(delta: float) -> void:
	if frame_buffer > 0:
		frame_buffer -= 1
		return
	if lifetime:
		duration -= delta
		if duration <= 0:
			self.queue_free()

func _ready() -> void:
	_make_collider()
	self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_body_entered)
func _on_body_entered(body) -> void:
	if check_line_walls:
		if !_can_target(body):
			return
	if body.has_method("_get_hit"):
		if body is CharacterHitbox and body.is_extra and exclude_extra:
			return
		if body.has_method("_set_deathquotes"):
				body._set_deathquotes(death_quote)
		var k = inertia
		if radial_knockback:
			k = self.global_position.direction_to(body.global_position) * inertia.length()
		if body._get_hit(damage_amt, damage_type, damage_source, k):
			if projectile:
				projectile._hit_made()
			if pierce == 0:
				self.queue_free()
			pierce -= 1

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
