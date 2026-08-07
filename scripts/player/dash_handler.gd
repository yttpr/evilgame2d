class_name DashHandler

extends Node2D

@export var Player : PlayerBody
@export var distance : float
@export var i_frames : float

@export var by_mouse : bool

func _dash() -> void:
	if Player.i_frame > 0:
		return
	Player.i_frame += i_frames
	if by_mouse:
		var mouse = Player.to_global(Player.get_local_mouse_position())
		var dir = Player.global_position.direction_to(mouse)
		Player.inertia += dir * distance
	else:
		Player.inertia += Player.velocity.normalized() * distance

func _input(event: InputEvent) -> void:
	if Manager.is_paused:
		return
	if Player.is_dead:
		return
	
	if event is InputEventMouseButton:
		if event.button_index != 2 or !event.pressed:
			return
		_dash()
