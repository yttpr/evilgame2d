class_name GangupEnemy

extends BaseBody

@export var Weapon : EnemyWeapon

var trigger_delay : float

func _listen_alert(alert_name : String, sender : Node2D, args : Variant) -> void:
	super._listen_alert(alert_name, sender, args)
	if trigger_delay > 0:
		return
	await get_tree().create_timer(0.05).timeout
	
	if self.is_dead or self.HP <= 0:
		return
	var dir = Weapon.global_position.direction_to(Manager.Player.global_position).normalized()
	Weapon._shoot(dir)
	trigger_delay = 0.1

func _process(delta: float) -> void:
	super._process(delta)
	if trigger_delay > 0:
		trigger_delay -= delta
