class_name NonsolidDestructible

extends BaseDestructible

@export var nonsolid : bool = true

func _ready() -> void:
	super._ready()
	self.set_collision_layer_value(4, !nonsolid)
