class_name ShopPoolWeaponInteractible

extends WeaponInteractible

@export var pool : ShopPoolData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_get_weapon()
	super._ready()

func _get_weapon() -> void:
	var list = []
	list.assign(pool.base_pool)
	for item in pool.unlocks:
		if Manager._check_save_bool(item.id):
			list.append(item)
	weapon = list[randi_range(0, list.size() - 1)]
