class_name GroupingBody

extends BaseBody

@export var brain : GeneralPathfinding

static var group : Array[GroupingBody] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !group:
		group = []
	group.append(self)
	super._ready()
func _cleanup() -> void:
	group.erase(self)
	super._cleanup()

func _on_hit(amt : int, type : String, source : String) -> void:
	super._on_hit(amt, type, source)
	if source.contains("Player"):
		_alert(self.global_position)

func _self_alert(pos : Vector2) -> void:
	if brain._can_see(Manager.Player):
		return
	brain._set_follow(Manager.Player, true)
	brain.follow_seen = Vector2(pos)
	brain.did_see = true
	brain._set_target(brain.follow_seen)

static func _alert(pos : Vector2) -> void:
	for enemy in group:
		if !enemy:
			continue
		enemy._self_alert(pos)
