class_name LoopExplodeProjectile

extends ExplodingProjectile

@export var interval_time : float
var interval_tick : float

func _ready() -> void:
	#super._ready()
	interval_tick = interval_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	interval_tick -= delta
	if interval_tick <= 0:
		interval_tick = interval_time
		_explode()
