class_name CharacterHitbox

extends Node

@export var body : BaseBody
@export var hitbox_type : String

@export var exclude_list : bool
@export var sources : Array[String]

var is_extra = true

func _get_hit(amt : int, type : String, source : String, mov : Vector2) -> bool:
	if source and sources:
		var found = false
		var bul = source.get_slice("_", 1)
		for t in sources:
			if t == bul:
				found = true
				break
		if exclude_list == found:
			return false
	
	return body._get_hit(amt, type, source, mov, true)
