class_name CycleBulletsListWeapon

extends AutoEnemyWeapon

@export var bullet_list : Array[PackedScene]
@export var amt_list : Array[int]
@export var type_list : Array[String]
var bullet_index : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	bullet_index = -1
	_update_bullet()
	tick = timer

func _made_shot() -> void:
	bullet_index += 1
	if bullet_index >= bullet_list.size():
		bullet_index = 0
	_update_bullet()
	timer = floor_timer + timer_mod * (1.0 - movable.HP / themax_hp)

func _update_bullet() -> void:
	if bullet_index <= 0:
		bullet = bullet_list[0]
		shot_amount = amt_list[0]
		damage_type = type_list[0]
		return
	bullet = bullet_list[bullet_index]
	shot_amount = amt_list[bullet_index]
	damage_type = type_list[bullet_index]

@export var themax_hp : float
@export var floor_timer : float
@export var timer_mod : float
