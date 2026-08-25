class_name DamageIcon

extends Sprite2D

@export var max_height : float
@export var max_range : float
@export var time : float

@export var cos : Color
@export var sin : Color

@export var start_range : float
@export var start_height : float
@export var height_range : float

@export var done_color : Color
@export var keep_color : bool

@export var dont_flip : bool

var right : bool

func _begin() -> void:
	right = randf_range(0.0, 1.0) < 0.5
	self.offset.x = randf_range(0.0, start_range)
	if !right:
		self.offset.x = self.offset.x * -1
	self.offset.y = start_height * -1
	#self.offset.y += randf_range(height_range * -1, height_range)
	if !dont_flip:
		self.flip_h = randf_range(0.0, 1.0) < 0.5

func _animate() -> void:
	#rangetween
	var pos = Vector2(self.position.x, self.position.y)
	var mod = randf_range(0, max_range)
	if !right:
		mod = mod * -1
	pos.x += mod
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", pos, time)

	#color tween
	var tween3 = get_tree().create_tween()
	tween3.set_ease(Tween.EASE_IN)
	tween3.tween_property(self, "self_modulate", done_color, time)
	
	#height tween
	var tween2 = get_tree().create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(self, "offset", Vector2(offset.x, (start_height * -1) + (max_height * -1) + randf_range(height_range * -1, height_range)), time)
	tween2.tween_callback(self._is_done)

func _set_color(is_sin : bool) -> void:
	if is_sin:
		self.self_modulate = sin
	else:
		self.self_modulate = cos
	if keep_color:
		self.done_color = Color(self.self_modulate.r, self.self_modulate.g, self.self_modulate.b, 0)

func _is_done() -> void:
	self.queue_free()
