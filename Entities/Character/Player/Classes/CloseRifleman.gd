extends "res://Entities/Character/Character.gd"

export var bullet_spread = 100.0

func _ready():
	self.get_node("AnimationPlayer").get_animation("CloseRiflemanRecoil").set_length(float(2 * shoot_cooldown))
