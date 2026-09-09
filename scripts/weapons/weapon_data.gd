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
@export var skip_auto_reload : bool

@export var aim_bounces : bool
@export var aim_length : float

@export var has_chargeup : bool
@export var charge_time : float
@export var charge_line_length : float
@export var charge_line_width : float
@export var chargeup_sound : AudioStream
@export var charge_sound_mod : float
@export var charge_sound_min_pitch : float = 1.0
@export var charge_sound_max_pitch : float = 2.0

@export var ready_audio : AudioStream
@export var audio_mod : float

@export var inert : bool

@export var melee : bool
@export var melee_range : float
