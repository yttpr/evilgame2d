class_name AudioSlider

extends VSlider

@export var bus_name : String

func _ready() -> void:
	value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(bus_name))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
