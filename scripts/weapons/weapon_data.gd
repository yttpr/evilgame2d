class_name WeaponData

extends Resource

@export var id : String

@export var weapon_img : Texture2D
@export var bullet : PackedScene
@export var bullet_type : String
@export var weapon_type : String

@export var damage_amt : int
@export var damage_type : String
@export var knockback : float
@export var pierce_amt : int

@export var full_auto : bool

@export var clip_size : int
@export var shot_delay : float
@export var reload_time : float

@export var aim_bounces : bool
@export var aim_length : float

@export var ready_audio : AudioStream
@export var audio_mod : float

@export var inert : bool

@export var melee : bool
@export var melee_range : float
