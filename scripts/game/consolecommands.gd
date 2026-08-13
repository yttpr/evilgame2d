class_name ConsoleCommands

extends LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.lock_input = false
	self.visible = false
	text_submitted.connect(self._on_text_submitted)

func _on_text_submitted(command : String) -> void:
	var use : String = command.to_lower()
	var args : PackedStringArray = use.split(" ")
	#print(command)
	
	if args.size() < 2:
		print("ummm invalid command epic fail")
		return
	
	if args[0] == "addweapon" or args[0] == "addgun":
		var weapon : WeaponData = ResourceLoader.load("res://assets/weapons/" + args[1] + ".tres")
		if !weapon:
			print("invalid weapon")
			return
		Manager.Player.weapon_handler._add_weapon(weapon)
	if args[0] == "setweapon" or args[0] == "setgun" or args[0] == "changeweapon" or args[0] == "changegun":
		var weapon : WeaponData = ResourceLoader.load("res://assets/weapons/" + args[1] + ".tres")
		if !weapon:
			print("invalid weapon")
			return
		Manager.Player.weapon_handler._swap_weapon(weapon, Manager.current_gun_index)
	if args[0] == "setenemy" or args[0] == "addenemy" or args[0] == "getenemy":
		var enemy : PackedScene = ResourceLoader.load("res://assets/enemies/" + args[1] + ".tscn")
		if !enemy:
			print("invalid enemy")
			return
		current_enemy = enemy
	if args[0] == "money":
		Manager.coins += int(args[1])
	if args[0] == "heal":
		Manager.current_hp = 10
		Manager.Player.HP = 10
		Manager.Player.ui.Health._set_current_health(Manager.current_hp)


func _in_focus() -> void:
	self.visible = true
	Manager.lock_input = true
	current_enemy = null
func _not_focus() -> void:
	self.visible = false
	Manager.lock_input = false



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if !self.visible:
			return
		_spawn_enemy(current_enemy, Manager.Player.to_global(Manager.Player.get_local_mouse_position()))
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_QUOTELEFT:
			if !Manager.lock_input:
				self.grab_focus()
			else:
				self.release_focus()

var current_enemy : PackedScene
func _spawn_enemy(reference : PackedScene, pos : Vector2) -> BaseBody:
	if !current_enemy:
		return
	var enemy : BaseBody = reference.instantiate()
	Manager._get_world().add_child(enemy)
	enemy.global_position = pos
	return enemy
