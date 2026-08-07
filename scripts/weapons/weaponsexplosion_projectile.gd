class_name ExplosionProjectile

extends BasicProjectile

@export var sin_image : Sprite2D
@export var cos_image : Sprite2D
@export var smoke_img : Sprite2D

@export var radius : float
@export var explosion_time : float
@export var smoke_time : float

func _shoot(direction : Vector2, origin : Vector2) -> void:
	super._shoot(direction, origin)
	
	self.global_position = origin
	_make_collider().global_position = origin - _offset()
	
	var tween3 = get_tree().create_tween()
	tween3.set_ease(Tween.EASE_OUT)
	tween3.tween_property(cos_image, "modulate", Color(1, 1, 1, 0), explosion_time)
	tween3.parallel().tween_property(sin_image, "modulate", Color(1, 1, 1, 0), explosion_time)
	
	smoke_img.scale = Vector2.ONE * 0.5
	var tween2 = get_tree().create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(smoke_img, "modulate", Color(1, 1, 1, 0), smoke_time)
	tween2.parallel().tween_property(smoke_img, "scale", Vector2.ONE * 1.5, smoke_time)
	tween2.tween_callback(_cleanup)

func _set_basic_data(amt : int, t : String, knock : float) -> void:
	super._set_basic_data(amt, t, knock)
	
	if type == "Cos":
		cos_image.visible = true
		sin_image.visible = false
	elif type == "Sin":
		cos_image.visible = false
		sin_image.visible = true


func _make_collider() -> DamageCollider:
	var collider = Manager._create_dmg_collider(dmg, type, source, Vector2.ONE * knockback_mod)
	collider.radial_knockback = true
	collider._set_parent(self)
	collider._set_pierce(-1)
	collider._set_circle(radius)
	collider._set_duration(true, explosion_time)
	collider._set_collision(Manager.collision_all)
	collider.death_quote = death_quote
	return collider
