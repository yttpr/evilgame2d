class_name MovingPhaser

extends Node2D

@export var body : BaseBody
@export var max_alpha : float = 1.0
@export var min_alpha : float = 0.0

@export var rate : float = 0.85


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body.modulate.a = min_alpha


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Manager.Player:
		return
	var mod = rate * delta
	
	if Manager.Player.velocity.length() > 0.0:
		body.modulate.a = min(max_alpha, body.modulate.a + mod)
	else:
		body.modulate.a = max(min_alpha, body.modulate.a - mod)
	
	#print(body.modulate)
