class_name WeaponDisplay

extends Node2D

@export var displays : Array[WeaponPortrait]
@export var offset : float
@export var reload : Sprite2D

@export var active : Color
@export var inactive : Color

var inv_amt : int

var active_index : int = -1
var is_reloading : bool

func _set_weapons_data(datas : Array[WeaponData]) -> void:
	inv_amt = datas.size()
	Manager.current_weapons.assign(datas)
	for i in datas.size():
		if i < displays.size():
			displays[i].visible = true
		else:
			var img = displays[displays.size() - 1].duplicate()
			img.visible = true
			self.add_child(img)
			img.position = displays[displays.size() - 1].position
			img.position.x += offset
			displays.append(img)
		
		if datas[i].damage_type == "Sin":
			displays[i].frame.modulate = Manager.sin_color
			#displays[i].cooldown.modulate = Manager.sin_color
		elif datas[i].damage_type == "Cos":
			displays[i].frame.modulate = Manager.cos_color
			#displays[i].cooldown.modulate = Manager.cos_color
		elif datas[i].damage_type == "NULL":
			displays[i].frame.modulate = Color.WHITE
			#displays[i].cooldown.modulate = Color.WHITE
		displays[i].weapon.texture = datas[i].weapon_img
	
	#clean extra
	if datas.size() < displays.size():
		for i in displays.size():
			if i < datas.size():
				continue
			displays[i].visible = false
func _set_active_weapon(index : int) -> void:
	if active_index == index:
		return
	active_index = index
	reload.position = displays[active_index].position
	if is_reloading:
		return
	for i in displays.size():
		if i == active_index:
			displays[i].modulate = active
		else:
			displays[i].modulate = inactive

func _set_reloading(value : bool) -> void:
	is_reloading = value
	reload.visible = is_reloading
	if is_reloading:
		displays[active_index].modulate = inactive
	else:
		displays[active_index].modulate = active

func _update_reloads() -> void:
	if inv_amt != Manager.Player.weapon_handler.reload_lefts.size():
		return
	if Manager.current_weapons.size() != inv_amt:
		return
	for i in inv_amt:
		if i != active_index:
			displays[i].cooldown.scale.y = Manager.Player.weapon_handler.reload_lefts[i] / Manager.current_weapons[i].reload_time
		else:
			displays[i].cooldown.scale.y = Manager.Player.weapon_handler.reload_tick / Manager.current_weapons[i].reload_time

func _process(delta : float) -> void:
	if is_reloading:
		reload.rotate(6 * delta)
	
	_update_reloads()
