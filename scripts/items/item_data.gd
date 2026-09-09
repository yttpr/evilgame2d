class_name ItemData

extends Resource

@export var id : String
@export var image : Texture2D
@export var active : bool
@export var logic : Script

# basic data
##string : float
@export var addition_mod : Dictionary[String, float]
##string : float
@export var multi_mod : Dictionary[String, float]

#costs
@export var inert : bool
##Cooldown, Coin, Heart, Item, Danger, None
@export var cost_type : String
@export var cost_amt : float
@export var check_player_health : bool

# extra
@export var reset_player : bool
