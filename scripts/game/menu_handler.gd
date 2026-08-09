class_name MenuHandler

extends Control

@export var border : Node2D

@export var buttons : Array[Control]
@export var audiosliders : Array[Control]

@export var death_handler : DeathQuotesHandler

@export var in_time : float

@export var anim_spd : float

@export var in_size : Vector2
@export var out_size : Vector2
@export var leave_size : Vector2

@export var ui_audio : AudioStream

var current_tween : Tween
var quote_tween : Tween

func _animate_border(state : String) -> void:
	if current_tween:
		current_tween.kill()
	
	var time = anim_spd
	
	var end = in_size
	if state == "Exit":
		end = leave_size
		time = in_time
	if state == "2":
		end = out_size
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	if state == "Enter":
		tween.set_ease(Tween.EASE_OUT)
		time = in_time
	elif state == "Exit":
		tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(border, "scale", end, time)
	current_tween = tween
	
	if state == "Enter" or state == "1":
		tween.tween_callback(_wane)
	elif state == "2":
		tween.tween_callback(_wax)
	elif state == "Exit":
		tween.tween_callback(_hide)
	
	if death_handler.visible:
		if quote_tween:
			quote_tween.kill()
		quote_tween = get_tree().create_tween()
		var qend = Vector2(1.7, 1.7)
		if state == "Exit":
			qend = leave_size
		if state == "2":
			qend = Vector2(1.9, 1.9)
		quote_tween.set_ease(Tween.EASE_IN_OUT)
		if state == "Enter":
			quote_tween.set_ease(Tween.EASE_OUT)
		elif state == "Exit":
			quote_tween.set_ease(Tween.EASE_OUT)
		quote_tween.set_trans(Tween.TRANS_QUAD)
		quote_tween.tween_property(death_handler, "scale", qend, time)


func _enter() -> void:
	self.scale = Vector2.ONE / Manager.Player.camera.zoom.x
	
	if Manager.Player.is_dead:
		death_handler._set_quotes(Manager.Player.death_quotes)
		death_handler.visible = true
		death_handler.scale = leave_size
	else:
		death_handler.visible = false
	
	if current_tween:
		current_tween.kill()
	border.scale = leave_size
	border.visible = true
	_animate_border("Enter")
	in_audio = false
	for slider in audiosliders:
		slider.visible = false
		if slider is Slider:
			var s : Slider = slider
			s.editable = false
		if slider is BaseButton:
			var b : BaseButton = slider
			b.disabled = false
	for button in buttons:
		button.visible = true
		if button is BaseButton:
			var b : BaseButton = button
			b.disabled = false
		if button is ContinueButton:
			var c : ContinueButton = button
			c._play_sound()
	if Manager.Player.is_dead:
		for slider in audiosliders:
			slider.visible = false
			if slider is Slider:
				var s : Slider = slider
				s.editable = false
			if slider is BaseButton:
				var b : BaseButton = slider
				b.disabled = false
func _wane() -> void:
	_animate_border("2")
func _wax() -> void:
	_animate_border("1")
func _hide() -> void:
	border.visible = false
func _exit() -> void:
	if current_tween:
		current_tween.kill()
	_animate_border("Exit")
	for button in buttons:
		button.visible = false
		if button is BaseButton:
			var b : BaseButton = button
			b.disabled = true
	for slider in audiosliders:
		slider.visible = false
		if slider is Slider:
			var s : Slider = slider
			s.editable = false


func _process(delta : float) -> void:
	if Manager.is_paused and current_tween:
		current_tween.custom_step(1.0 / 60.0)


var in_audio : bool
func _toggle_audio() -> void:
	if !Manager.in_menu:
		return
	GlobalNoise._play_sound(ui_audio, 0, 0.85)
	in_audio = !in_audio
	if !in_audio: # return to normal menu
		for slider in audiosliders:
			slider.visible = false
			if slider is Slider:
				var s : Slider = slider
				s.editable = false
		for button in buttons:
			button.visible = true
			if button is BaseButton:
				var b : BaseButton = button
				b.disabled = false
	else: #go to audio menu
		for button in buttons:
			button.visible = false
			if button is BaseButton:
				var b : BaseButton = button
				b.disabled = true
		for slider in audiosliders:
			slider.visible = true
			if slider is BaseButton:
				var b : BaseButton = slider
				b.disabled = false
			if slider is Slider:
				var s : Slider = slider
				s.editable = true
