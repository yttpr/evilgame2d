class_name DeathQuotesHandler

extends Node2D

@export var points_display : Label
@export var quote_holders : Array[Label]

func _set_quotes(quotes : Array[String]) -> void:
	if !quotes or quotes.size() <= 0:
		quotes = [""]
	
	for label in quote_holders:
		if label.has_theme_font_size_override("new"):
			label.remove_theme_font_override("new")
		label.add_theme_font_size_override("new", randi_range(5, 8))
		label.text = quotes[randi_range(0, quotes.size() - 1)]
		if label is VibrateLabel:
			label.loc_var = randf_range(0.38, 1)


func _process(delta: float) -> void:
	points_display.text = Manager.Player.character + " : " + str(Manager.points)
