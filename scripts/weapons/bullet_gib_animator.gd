class_name BulletGibAnimator

extends Node2D

@export var sprite : Sprite2D
@export var tick_spd : float

var tick : float

func _set_offset(off : Vector2) -> void:
	sprite.position = off
func _set_color(mod : Color) -> void:
	sprite.modulate = mod

func _ready() -> void:
	tick = tick_spd

func _process(delta : float) -> void:
	tick -= delta
	if tick <= 0:
		tick = tick_spd
		if sprite.frame + 1 >= sprite.hframes:
			self.queue_free()
		else:
			sprite.frame += 1
