class_name CharacterAnimator

extends Sprite2D

@export var body : CharacterBody2D
@export var hitbox : Area2D
@export var walk_time : float = 0.15

@export var footstep : AudioStream
@export var audio_mod : float = 6
@export var audio : BasicAudio
@export var step_change : float

func _ready() -> void:
	down = true

var down : bool
var pace : float
var walk : int
var reg : int
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Manager.is_paused:
		return
	if body is PlayerBody and body.is_dead:
		return
	
	if body.velocity.x < 0:
		self.flip_h = false
		if hitbox:
			hitbox.scale.x = 1.0
	elif body.velocity.x > 0:
		self.flip_h = true
		if hitbox:
			hitbox.scale.x = -1.0
	if body.velocity.y < 0:
		down = false
	elif body.velocity.y > 0:
		down = true
	elif body is PlayerBody and body.velocity.y == 0:
		var ax = Input.get_axis("ui_up", "ui_down")
		if ax < 0:
			down = false
		elif ax > 0:
			down = true
	
	if body.velocity.length() < 5:
		walk = 1
		pace = walk_time
		if down and reg != 0:
			self.frame = 0
			reg = 0
		elif !down and reg != 1:
			self.frame = 1
			reg = 1
	else:
		pace -= delta
		if pace <= 0:
			if walk > 0:
				walk = 0
				if footstep:
					audio._play_sound(footstep, audio_mod)
			else:
				walk = 1
				if footstep:
					audio._play_sound(footstep, audio_mod, step_change)
			pace = walk_time
		
		if down:
			if walk == 1 and reg != 3:
				self.frame = 3
				reg = 3
			elif walk == 0 and reg != 2:
				self.frame = 2
				reg = 2
		else:
			if walk == 1 and reg != 5:
				self.frame = 5
				reg = 5
			elif walk == 0 and reg != 4:
				self.frame = 4
				reg = 4
