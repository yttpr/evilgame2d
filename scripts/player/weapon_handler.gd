class_name WeaponManager

extends Node2D

@export var Player : PlayerBody
@export var weilder_name : String
@export var weapon : WeaponAnimator
@export var secondary : Sprite2D
@export var pointer : Node2D
@export var audio_player : BasicAudio

var gun_index = 0
@export var weapons : Array[WeaponData]
var remaining_clips : Array[int]
var reload_lefts : Array[float]

@export var bullet : PackedScene
@export var source_name : String

@export var aim_color : Color
@export var aim_width : float
@export var does_bounce : bool
@export var line_length : float

@export var max_clip : int
@export var shot_delay : float
@export var reload_icon : Sprite2D
@export var reload_time : float

#for bullet info
@export var knockback : float
@export var damage_type : String
@export var dmg_amt : int
@export var pierce_amt : int

var current_clip : int
var alt_clip : int

var mouse_loc : Vector2

var delay_tick : float

var is_reloading : bool
var reload_tick : float

@export var melee_collider : DamageCollider
@export var melee_line : CollisionShape2D
func _set_melee(enabled : bool, length : float) -> void:
	melee_line.set_deferred("disabled", !enabled)
	melee_line.shape.b.x = length
	melee_collider.damage_amt = weapons[gun_index].damage_amt
	melee_collider.damage_type = weapons[gun_index].damage_type
	melee_collider.inertia = Vector2(weapons[gun_index].knockback, 0)

func _set_data(data : WeaponData) -> void:
	weapon.texture = data.weapon_img
	bullet = data.bullet
	source_name = weilder_name + "_" + data.bullet_type
	dmg_amt = data.damage_amt
	damage_type = data.damage_type
	knockback = data.knockback
	pierce_amt = data.pierce_amt
	run_full_auto = data.full_auto
	max_clip = data.clip_size
	shot_delay = data.shot_delay
	reload_time = data.reload_time
	does_bounce = data.aim_bounces
	line_length = data.aim_length
	_update_color()
	Player.ui.Ammo._set_clip_size(max_clip)
	Player.ui.Ammo._set_damage_type(damage_type)
	Player.ui.Ammo._set_weapon_type(data.weapon_type)
	_set_melee(data.melee, data.melee_range)
	if secondary:
		secondary.texture = weapons[_alt_weapon(gun_index)].weapon_img
func _alt_weapon(current : int) -> int:
	var ret = current + 1
	if ret >= weapons.size():
		ret = 0
	return ret
func _change_weapon(amt : int) -> int:
	remaining_clips[gun_index] = current_clip
	reload_lefts[gun_index] = reload_tick
	gun_index = amt
	if gun_index < 0:
		gun_index = weapons.size() - 1
	if gun_index >= weapons.size():
		gun_index = 0
	Manager.current_gun_index = gun_index
	_set_data(weapons[gun_index])
	reload_tick = reload_lefts[gun_index]
	_set_reload(reload_lefts[gun_index] > 0, false)
	if !is_reloading:
		current_clip = remaining_clips[gun_index]
		Player.ui.Ammo._set_loaded_amt(current_clip)
	else:
		Player.ui.Ammo._set_loaded_amt(0)
	Player.ui.Weapons._set_active_weapon(gun_index)
	return gun_index
func _reset_alt_clip() -> void:
	alt_clip = weapons[_alt_weapon(gun_index)].clip_size

var run_full_auto : bool
var mouse_down : bool

func _input(event: InputEvent) -> void:
	if Manager.is_paused:
		return
	if Player.is_dead:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R and !is_reloading:
			_set_reload(true)
		if event.keycode == KEY_SHIFT:
			_change_weapon(gun_index + 1)
		#get numkeys
		if event.keycode == KEY_1:
			if weapons.size() > 0:
				_change_weapon(0)
		if event.keycode == KEY_2:
			if weapons.size() > 1:
				_change_weapon(1)
		if event.keycode == KEY_3:
			if weapons.size() > 2:
				_change_weapon(2)
		if event.keycode == KEY_4:
			if weapons.size() > 3:
				_change_weapon(3)
		if event.keycode == KEY_5:
			if weapons.size() > 4:
				_change_weapon(4)
		if event.keycode == KEY_6:
			if weapons.size() > 5:
				_change_weapon(5)
		if event.keycode == KEY_7:
			if weapons.size() > 6:
				_change_weapon(6)
		if event.keycode == KEY_8:
			if weapons.size() > 7:
				_change_weapon(7)
		if event.keycode == KEY_9:
			if weapons.size() > 8:
				_change_weapon(8)
		if event.keycode == KEY_0:
			if weapons.size() > 9:
				_change_weapon(9)
		
	if event is InputEventMouseButton:
		#weapon change
		if event.is_pressed():
			#zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_change_weapon(gun_index - 1)
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_change_weapon(gun_index + 1)
		
		if event.button_index == 1:
			mouse_down = event.pressed
		
		#shooting
		if is_reloading or delay_tick > 0:
			return
		if event.button_index != 1 or !event.pressed:
			return
		if weapons[gun_index].inert:
			return
		if !Manager.world:
			return
		_shoot()

func _shoot() -> void:
	var proj : BasicProjectile = bullet.instantiate()
	Manager._get_world().add_child(proj)
	proj._set_basic_data(dmg_amt, damage_type, knockback)
	var mouse = to_global(get_local_mouse_position())
	var dir = pointer.global_position.direction_to(mouse)
	proj._set_collision(source_name, Manager.collision_walls, Player.Hitbox)
	proj.pierce_amt = pierce_amt
	proj.y_change = _get_offset()
	var loc = pointer.global_position
	if Manager._check_in_wall(loc - _get_offset_vector()):
		loc = weapon.global_position
	proj._shoot(dir, loc)
	
	current_clip -= 1
	Player.ui.Ammo._spend_loaded(1)
	delay_tick += shot_delay
	if current_clip <= 0:
		_set_reload(true)
	
	Manager._get_world()._post_alert("PlayerShoot", self, damage_type)


func _get_offset() -> float:
	return weapon.position.y
func _get_offset_vector() -> Vector2:
	return Vector2(0, _get_offset())
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_down = false
	if Manager.current_gun_index >= 0:
		gun_index = Manager.current_gun_index
	if Manager.current_weapons.size() > 0:
		weapons.assign(Manager.current_weapons)
	Player.ui.Weapons._set_weapons_data(weapons)
	_reset_arrays()
	_set_reload(false)
	_set_data(weapons[gun_index])
	Player.ui.Weapons._set_active_weapon(gun_index)
	_reset_alt_clip()
func _setup() -> void:
	Player.ui.Weapons._set_weapons_data(weapons)
	_reset_arrays()
	if gun_index >= weapons.size():
		gun_index = weapons.size() - 1
	_set_data(weapons[gun_index])
	Player.ui.Weapons._set_active_weapon(gun_index)
	_set_reload(false)
	_reset_alt_clip()
func _reset_arrays() -> void:
	reload_lefts = []
	remaining_clips = []
	for weapon in weapons:
		reload_lefts.append(0)
		remaining_clips.append(weapon.clip_size)

func _add_weapon(data : WeaponData) -> void:
	if weapons.size() >= 10:
		return
	weapons.append(data)
	Player.ui.Weapons._set_weapons_data(weapons)
	reload_lefts.append(0)
	remaining_clips.append(data.clip_size)
	Manager.current_weapons.assign(weapons)
	_change_weapon(weapons.size() - 1)
func _swap_weapon(data : WeaponData, id : int) -> void:
	if weapons.size() <= id:
		return
	weapons[id] = data
	Player.ui.Weapons._set_weapons_data(weapons)
	reload_lefts[id] = 0
	remaining_clips[id] = data.clip_size
	reload_tick = 0
	if id == gun_index:
		_change_weapon(id)
		_set_reload(false)
	Manager.current_weapons.assign(weapons)

func _set_reload(reloading : bool, reset_alt : bool = true) -> void:
	if Player.ui.Ammo.clip != max_clip:
		Player.ui.Ammo._set_clip_size(max_clip)
	if reloading:
		reload_icon.visible = true
		audio_player._play_sound(Manager.reload_loop, 5.0)
		is_reloading = true
		if reload_tick <= 0:
			reload_tick = reload_time
		else:
			reload_tick = min(reload_tick, reload_time)
	else:
		reload_icon.visible = false
		audio_player.stop()
		if weapons[gun_index].ready_audio:
			audio_player._play_sound(weapons[gun_index].ready_audio, weapons[gun_index].audio_mod)
		is_reloading = false
		current_clip = max_clip
		if reset_alt:
			_reset_alt_clip()
		Player.ui.Ammo._set_loaded_amt(current_clip)
		delay_tick = 0.0
	Player.ui.Weapons._set_reloading(reloading)
func _update_color() -> void:
	if damage_type == "Sin":
		aim_color = Manager.sin_color
	elif damage_type == "Cos":
		aim_color = Manager.cos_color
	else:
		aim_color = Color.YELLOW

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player.is_dead:
		audio_player.stop()
		return
	
	if run_full_auto and mouse_down and delay_tick <= 0 and !is_reloading and !weapons[gun_index].inert and Manager.world:
		_shoot()
	
	if delay_tick > 0:
		delay_tick -= delta
	if is_reloading:
		reload_icon.rotate(delta * 6)
		reload_tick -= delta
		if reload_tick <= 0:
			_set_reload(false)
	
	var mouse = to_global(get_local_mouse_position())
	
	if weapon.global_position.distance_to(mouse) < weapon.global_position.distance_to(pointer.global_position):
		return
	
	if !is_reloading and !Player.is_dead:
		_next_line(true, line_length, delta, pointer.global_position - _get_offset_vector(), _process_mouse_loc(mouse) - _get_offset_vector(), [])



#aiming stuff
func _next_line(aiming : bool, length : float, delta : float, origin: Vector2, target_point : Vector2, exclude : Array[RID]) -> Vector2:
	
	#var tarjet = _set_vector_magnitude(target_point, origin, length)
	#make query
	var query = PhysicsRayQueryParameters2D.create(origin, target_point, Manager.collision_walls.collision_mask, exclude)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(query);
	
	if result:
		
		#result.position -= _get_offset_vector()
		
		if aiming:
			_draw_line(delta, aim_color, aim_width, origin, result.position)
		
		# get bounce vector
		var orig = result.position - origin
		length -= orig.length()
		if length <= 0 or result.normal == Vector2.ZERO or !does_bounce:
			return result.position
		
		var aim = orig.bounce(result.normal)
		var finish = _set_vector_magnitude(aim, Vector2.ZERO, length)
		
		return _next_line(aiming, length, delta, result.position + finish.normalized(), result.position + finish, [])
	
	if aiming:
		_draw_line(delta, aim_color, aim_width, origin, target_point)
	
	return target_point

func _draw_line(time: float, color : Color, width : float, orig : Vector2, pos : Vector2) -> void:
	if pos.y > orig.y:
		var temp = pos
		pos = orig
		orig = temp
	
	var line = Line2D.new()
	if Manager.world:
		Manager._get_world().add_child(line)
	line.global_position = orig
	line.global_rotation = 0
	#line.position = self.position
	line.add_point(Vector2.ZERO + _get_offset_vector())
	line.add_point(pos - line.global_position + _get_offset_vector())
	line.width = width
	line.modulate = color
	line.material = Manager._tracer_mat()
	line.y_sort_enabled = true
	line.show_behind_parent = true
	
	get_tree().create_timer(time * 2).timeout.connect(line.queue_free)
	

func _process_mouse_loc(location : Vector2) -> Vector2:
	return pointer.global_position + _set_vector_magnitude(location, pointer.global_position, line_length)

func _set_vector_magnitude(vector : Vector2, origin : Vector2, length : float) -> Vector2:
	return origin.direction_to(vector) * length
