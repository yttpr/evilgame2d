class_name GibHandler

extends Node

var blood_img : Texture2D
var gib_base : PackedScene

var blood_life_floor : float = 60
var blood_life_ciel : float = 120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blood_img = ResourceLoader.load("res://sprites/enemies/gibs/BasicBlood.png")
	gib_base = preload("res://assets/ui/basic_gib.tscn")


func _make_gibs(loc : Vector2, inertia : Vector2, data : GibData) -> void:
	for i in data.coins:
		_make_coin(loc, inertia)
	for i in data.blood_amt:
		_make_blood(loc, inertia, data.blood_color_1, data.blood_color_2)
	for i in data.floor_blood_amt:
		_make_blood(loc, Vector2.ZERO, data.blood_color_1, data.blood_color_2)
	
	if !data.images or !data.img_amts:
		return
	
	for i in data.images.size():
		if i >= data.img_amts.size():
			break
		var weight = 1.0
		var rotates = true
		if data.weights and data.weights.size() > i:
			weight = data.weights[i]
		if data.does_rotate and data.does_rotate.size() > i:
			rotates = data.does_rotate[i]
		for n in data.img_amts[i]:
			_make_gib(loc, inertia, data.images[i], weight, rotates)

func _make_gib(loc : Vector2, inertia : Vector2, img : Texture2D, weight = 1.0, do_rotate = true) -> void:
	var gib : GibBody = gib_base.instantiate()
	gib.img.texture = img
	gib.img.material = null
	gib.img.light_mask = 8
	#Manager._get_world().add_child(gib)
	Manager._get_world().call_deferred("add_child", gib)
	gib.global_position = loc
	gib.weight = weight
	if do_rotate:
		gib._random_rotate()
	gib._random_flip()
	gib._prep(inertia, true)
	gib._set_fall_in_pit(true)
func _make_coin(loc : Vector2, inertia : Vector2) -> void:
	var gib : GibBody = Manager.coin_sprite.instantiate()
	Manager._get_world().call_deferred("add_child", gib)
	gib.global_position = loc
	gib._random_rotate()
	#gib._random_flip()
	gib._prep(inertia, true)
	gib._set_fall_in_pit(true)


func _make_blood(loc : Vector2, inertia : Vector2, first : Color, second : Color) -> void:
	var blood : GibBody = gib_base.instantiate()
	blood.img.texture = blood_img
	blood.img.modulate = _get_random_color(first, second)
	blood.img.z_index = -3
	Manager._get_world().call_deferred("add_child", blood)
	blood.global_position = loc
	blood._random_rotate()
	blood._random_flip()
	blood.weight = 1
	blood._prep(inertia, false)
	blood._randomize_scale()
	blood._set_lifetime(randf_range(blood_life_floor, blood_life_ciel))

func _get_random_color(first : Color, second : Color) -> Color:
	var dif = randf_range(0.0, 1.0)
	var d_r = first.r - second.r
	var d_g = first.g - second.g
	var d_b = first.b - second.b
	var d_a = first.a - second.a
	
	return Color(first.r + d_r * dif, first.g + d_g * dif, first.b + d_b * dif, first.a + d_a * dif)
