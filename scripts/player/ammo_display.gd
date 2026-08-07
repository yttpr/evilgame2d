class_name AmmoDisplay

extends Node2D

@export var icons : Array[Sprite2D]
@export var offset : float

@export var bullet_icon : Texture2D
@export var magic_icon : Texture2D

@export var able : Color
@export var spent : Color

var damage_type : String
var weapon_type : String

var clip : int
var loaded : int

func _set_clip_size(amt : int) -> void:
	clip = amt
	for i in amt:
		if i < icons.size():
			icons[i].visible = true
		else:
			var img : Sprite2D = icons[icons.size() - 1].duplicate()
			img.visible = true
			self.add_child(img)
			self.move_child(img, 0)
			img.position = icons[icons.size() - 1].position
			img.position.x += offset
			icons.append(img)
	if amt < icons.size():
		for i in icons.size():
			if i < amt:
				continue
			icons[i].visible = false
func _set_loaded_amt(amt : int) -> void:
	loaded = amt
	for i in icons.size():
		if i < amt:
			icons[i].modulate = able
		else:
			icons[i].modulate = spent
func _spend_loaded(amt : int) -> void:
	for i in amt:
		if loaded > 0:
			loaded -= 1
			if loaded < icons.size():
				icons[loaded].modulate = spent

func _set_damage_type(type : String) -> void:
	if type == "Sin":
		self.modulate = Manager.sin_color
	elif type == "Cos":
		self.modulate = Manager.cos_color
	damage_type = type
func _set_weapon_type(type : String) -> void:
	if type == weapon_type:
		return
	weapon_type = type
	for icon in icons:
		if type == "Bullet":
			icon.texture = bullet_icon
		elif type == "Magic":
			icon.texture = magic_icon
