extends "res://Entities/Character/Character.gd"

func _ready():
	self.get_node("AnimationPlayer").get_animation("SoldierRecoil").set_length(float(2 * shoot_cooldown))
