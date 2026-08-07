class_name VibrateLabel

extends Label

@export var loc_var : float = 1
@export var rot_var : float = 0.0

var origin_loc : Vector2
var origin_rot : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin_loc = self.position
	origin_rot = self.rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = origin_loc + Vector2.from_angle(randf_range(0, PI*2)) * loc_var
	self.rotation = origin_rot + randf_range(rot_var * -1, rot_var)
