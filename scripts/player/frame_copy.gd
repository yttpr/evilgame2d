class_name FrameCopy

extends Sprite2D

@export var disable_this : bool

@export var source : Sprite2D
@export var is_highlight : bool = true
@export var copy_offset : bool = true

@export var is_hitbox : bool = false

func _ready() -> void:
	if is_highlight: 
		self.visible = false
	if is_hitbox:
		return
	hframes = source.hframes
	if copy_offset:
		offset = source.offset

@export var copy_player_health : bool
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if disable_this:
		self.visible = false
		return
	if is_highlight:
		self.visible = Manager.show_hitboxes
	if is_hitbox:
		if Manager.Player and Manager.Player.is_dead:
			self.visible = false
		return
	if is_highlight:
		texture = source.texture
	frame = source.frame
	flip_h = source.flip_h
	flip_v = source.flip_v
	
	if copy_player_health:
		var shader : ShaderMaterial = self.material
		if Manager.Player.healthtype == "Sin":
			shader.set_shader_parameter("outline_color", Manager.sin_color)
		elif Manager.Player.healthtype == "Cos":
			shader.set_shader_parameter("outline_color", Manager.cos_color)


func _input(event: InputEvent) -> void:
	return
	if !is_highlight:
		return
	if event is InputEventKey and event.keycode == KEY_SHIFT:
		if event.is_pressed():
			self.visible = !self.visible
		#else:
			#self.visible = false
