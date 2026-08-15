class_name ReactiveBody

extends BaseBody

@export var brain : ScreenMonitoringPathfinding
@export var bullet : PackedScene
@export var weapon : EnemyWeapon

var toggle : bool

func _on_hit(amt : int, type : String, source : String) -> void:
	if cooldown_tick > 0:
		return
	cooldown_tick = cooldown_time
	
	if source.contains("Player"):
		brain.on_screen = false
		brain._set_moving(true)
		brain._set_follow(Manager.Player, !brain.always)
		#brain.follow_seen = Manager.Player.global_position
		#brain.did_see = true
		
		_shoot(Vector2.DOWN)
		_shoot(Vector2.LEFT)
		_shoot(Vector2.RIGHT)
		_shoot(Vector2.UP)
		_shoot(Vector2(1, 1).normalized())
		_shoot(Vector2(1, -1).normalized())
		_shoot(Vector2(-1, -1).normalized())
		_shoot(Vector2(-1, 1).normalized())

@export var dmg_amt : int
@export var damage_type : String
@export var knockback : float
@export var source_name : String
@export var cooldown_time : float
var cooldown_tick : float

func _shoot(direction : Vector2) -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().call_deferred("add_child", proj)
	proj._set_basic_data(dmg_amt, damage_type, knockback)
	proj._set_collision(source_name, Manager.collision_walls, Manager.collision_forEnemy)
	proj.pierce_amt = 0
	proj.y_change = weapon._get_offset()
	proj._shoot(direction, self.global_position + weapon._get_offset_vector())

func _process(delta : float) -> void:
	super._process(delta)
	if cooldown_tick > 0:
		cooldown_tick -= delta

func _ready() -> void:
	super._ready()
	toggle = true
