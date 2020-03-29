extends "res://Entities/Character/Character.gd"

export (float) var zoom = 1.2

func _ready():
	$"Camera2D".zoom *= zoom 
