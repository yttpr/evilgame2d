class_name ReverseSightPathfinding

extends HomingPathfinding

func _can_see(targetNode : Node2D) -> bool:
	return true

func _can_target(targetNode : Node2D) -> bool:
	return !super._can_target(targetNode)


@export var indicator_image : Sprite2D
@export var alpha_rate : float = 0.4

func _ready() -> void:
	super._ready()
	if indicator_image:
		indicator_image.modulate.a = 0.0

func _process(delta: float) -> void:
	super._process(delta)
	
	if !indicator_image:
		return
	if Follow_Target:
		if !_can_target(Follow_Target):
			indicator_image.modulate.a = max(0.0, indicator_image.modulate.a - alpha_rate * delta)
		else:
			indicator_image.modulate.a = min(1.0, indicator_image.modulate.a + alpha_rate * delta)
