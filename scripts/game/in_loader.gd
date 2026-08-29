class_name LoaderImage

extends Node2D

@export var image : Sprite2D
@export var load_time : float = 8.0

@export var start : Vector2 = Vector2(0.01, 0.01)
@export var finish_revive : Vector2 = Vector2(8, 8)
@export var finish_room : Vector2 = Vector2(25, 25)

@export var offset : Vector2 = Vector2(0, -50)

var tick = 0
var triggered : bool = false
var running : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tick = 0
	triggered = false
	self.visible = true
	self.scale = start

func _anim(revive : bool) -> void:
	get_parent().remove_child(self)
	Manager._get_world().add_child(self)
	self.global_position = Manager.Player.global_position + offset
	self.scale = start
	var end = finish_room
	if revive:
		end = finish_revive
		image.frame = 0
	else:
		image.frame = 1
		load_time /= 2.0
	
	triggered = true
	var up = get_tree().create_tween()
	up.tween_property(self, "scale", end, load_time)
	up.tween_callback(self.queue_free)
	running = up
	
	var c = get_tree().create_tween()
	c.set_ease(Tween.EASE_OUT)
	c.set_trans(Tween.TRANS_SINE)
	c.tween_property(self, "modulate", Color(0, 0, 0, 0), load_time)


func _hide() -> void:
	self.visible = false
	self.scale = start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tick < 30:
		tick += 1
		return
	
	if !triggered and Manager.world:
		_anim(Manager._get_world().is_spawn)
