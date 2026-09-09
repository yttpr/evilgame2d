class_name AutoEnemyWeapon

extends EnemyWeapon

@export var timer : float
var tick : float
var toggle : bool

@export var only_front : bool = false
@export var movable : BaseBody

@export var only_cardinals : bool

@export var by_amount : bool
@export var shot_amount : int
@export var maxhealth : int
@export var healthinterval : int
@export var rot_spd : float
var cur_rot : float

@export var switch_on_interval : bool
@export var switch_min : float = 10.0
@export var switch_max : float = 30.0
var switch_tick : float
func _reset_switch_tick() -> void:
	switch_tick = randf_range(switch_min, switch_max)
var is_switch : float = 1.0

@export var ignore_brain_moving : bool

func _ready() -> void:
	super._ready()
	_reset_switch_tick()
	cur_rot = 0.0

func _rot_mod() -> float:
	if by_amount:
		var num : int = floori(float(maxhealth - brain.Movable.HP) / float(healthinterval))
		if num % 2 == 0:
			return 1.0
		else:
			return -1.0
	return 1.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	switch_tick -= delta
	if switch_tick <= 0:
		_reset_switch_tick()
		is_switch *= -1.0
	
	cur_rot += rot_spd * delta * _rot_mod() * is_switch
	if cur_rot >= 2*PI:
		cur_rot -= 2*PI
	
	tick -= delta
	if tick <= 0:
		_made_shot()
		tick = timer
		if only_front and movable and !movable.is_dead:
			_shoot(movable.velocity)
			is_agro = false
			if !ignore_brain_moving:
				brain._set_moving(true)
			return
		
		if by_amount:
			var num = shot_amount
			if maxhealth > 0:
				num += floori(float(maxhealth - brain.Movable.HP) / float(healthinterval))
			for i in num:
				_shoot(Vector2.from_angle(((2*PI) / num) * i + cur_rot))
			is_agro = false
			if !ignore_brain_moving:
				brain._set_moving(true)
			return
		
		if toggle or only_cardinals:
			_shoot(Vector2.DOWN)
			_shoot(Vector2.LEFT)
			_shoot(Vector2.RIGHT)
			_shoot(Vector2.UP)
		else:
			_shoot(Vector2(1, 1).normalized())
			_shoot(Vector2(1, -1).normalized())
			_shoot(Vector2(-1, -1).normalized())
			_shoot(Vector2(-1, 1).normalized())
		toggle = !toggle
	
	is_agro = false
	if !ignore_brain_moving:
		brain._set_moving(true)

func _made_shot() -> void:
	pass
