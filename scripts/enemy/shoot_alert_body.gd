class_name ShootAlertBody

extends BaseBody

@export var brain : ShootAlertPathfinding

func _listen_alert(alert_name : String, sender : Node2D, args : Variant) -> void:
	super._listen_alert(alert_name, sender, args)
	if alert_name == "PlayerShoot":
		print("hi")
		if brain._unique_can_see(Manager.Player):
			print("seen")
			brain.has_heard = true
