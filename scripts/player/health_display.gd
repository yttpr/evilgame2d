class_name HealthDisplay

extends Node2D
@export var icons : Array[Sprite2D]
@export var offset : float

@export var able : Color
@export var spent : Color

@export var normal : Texture2D
@export var overheal : Texture2D

var damage_type : String
var weapon_type : String

var max_hp : int
var current : int

func _set_max_health(amt : int) -> void:
	max_hp = amt
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
func _set_current_health(amt : int) -> void:
	current = amt
	if icons.size() < amt:
		for j in amt - icons.size():
			var img : Sprite2D = icons[icons.size() - 1].duplicate()
			img.visible = true
			self.add_child(img)
			self.move_child(img, 0)
			img.position = icons[icons.size() - 1].position
			img.position.x += offset
			icons.append(img)
	for i in icons.size():
		if i < amt:
			icons[i].visible = true
			icons[i].modulate = able
			if i < max_hp:
				icons[i].texture = normal
			else:
				icons[i].texture = overheal
		else:
			icons[i].modulate = spent
			icons[i].texture = normal
			if i >= max_hp:
				icons[i].visible = false
func _reduce_health(amt : int) -> void:
	for i in amt:
		if current > 0:
			current -= 1
			if current < icons.size():
				icons[current].modulate = spent
				if current >= max_hp:
					icons[current].visible = false

func _set_health_type(type : String) -> void:
	if type == "Sin":
		self.modulate = Manager.sin_color
	elif type == "Cos":
		self.modulate = Manager.cos_color
	damage_type = type
