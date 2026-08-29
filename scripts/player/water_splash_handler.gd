class_name WaterSplashHandler

extends SpriteAnimator

#var image : Sprite2D
var body : BaseBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !body or body.is_dead:
		self.queue_free()
		return
	
	super._process(delta)
	self.global_position = body.global_position + Vector2(0, 32)
