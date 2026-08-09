class_name PlayerStatsDisplay

extends Node2D

@export var Health : HealthDisplay
@export var Ammo : AmmoDisplay
@export var Weapons : WeaponDisplay
@export var Coins : Node2D

var corner : Vector2

func _ready() -> void:
	corner = Coins.position
	get_tree().root.size_changed.connect(_update_offset)
	
	await get_tree().process_frame
	_update_offset()

func _process(delta: float) -> void:
	pass

func _update_offset() -> void:
	Manager.Camera.ui_offset = Vector2(get_tree().root.content_scale_size.x / -2, get_tree().root.content_scale_size.y / -2)
	
	var xratio = float(get_viewport().size.x) / get_tree().root.content_scale_size.x
	var yratio = float(get_viewport().size.y) / get_tree().root.content_scale_size.y
	
	if xratio < yratio:
		Manager.Camera.ui_offset.y *= yratio / xratio
		Coins.position.y = corner.y * yratio / xratio
	if yratio < xratio:
		Manager.Camera.ui_offset.x *= xratio / yratio
		Coins.position.x = corner.x * xratio / yratio
	else:
		Coins.position = Vector2(corner)
	
	Manager.Camera._update_ui()
