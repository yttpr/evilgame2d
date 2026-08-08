class_name PoolListDoor

extends DoorInteractible

@export var paths : Array[String]
@export var exits : Array[int]
@export var weights : Array[int]


func _run() -> void:
	var num = _get_id()
	room = paths[num]
	spawn_pos = exits[num]
	super._run()


func _get_id() -> int:
	var top = 0
	for weight in weights:
		top += weight
	var num = randi_range(0, top - 1)
	var current = 0
	for i in weights.size():
		current += weights[i]
		if num < current:
			return i
	return 0
