class_name SpriteAnimator

extends Sprite2D


@export var delay : float
var tick : float

@export var randomize_start : bool
func _ready() -> void:
	tick = delay
	if randomize_start:
		frame = randi_range(0, hframes - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tick -= delta
	if tick <= 0:
		tick = delay
		if frame + 1 >= self.hframes:
			frame = 0
		else:
			frame += 1
