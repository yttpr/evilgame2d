class_name WTF_Class

extends Area2D

@export var pathfinder : ProjectilePathfinding
@export var in_range : Array[BaseBody]
var nearest : BaseBody

@export var process_tick : int = 30
var ticks : int

func _process(delta : float) -> void:
	ticks -= 1
	if ticks <= 0:
		ticks = process_tick
		_update_nearest()

func _on_body_entered(node : Node2D) -> void:
	if node is BaseBody:
		var body : BaseBody = node
		in_range.append(body)
		_update_nearest()
func _on_body_exited(node : Node2D) -> void:
	if node is BaseBody:
		var body : BaseBody = node
		in_range.erase(body)
		_update_nearest()

func _update_nearest() -> void:
	if in_range.size() <= 0:
		nearest = null
		return
	
	var dist : float = INF
	for obj in in_range:
		var lent = self.global_position.distance_to(obj.global_position)
		if lent < dist:
			dist = lent
			nearest = obj
	
	if nearest:
		pathfinder._set_follow(nearest)
