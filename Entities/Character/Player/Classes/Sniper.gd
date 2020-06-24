extends "res://Entities/Character/Character.gd"

export (float) var zoom = 1.2

func _ready():
	self.get_node("AnimationPlayer").get_animation("SniperRecoil").set_length(float(2 * shoot_cooldown))
	$"Camera2D".zoom *= zoom 
