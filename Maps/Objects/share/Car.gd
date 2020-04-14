extends "res://Maps/Objects/share/ObjectBase.gd"

func _on_BulletDeathArea_body_exited(body):
	if "distance_traveled" in body:
		body.distance_traveled += (body.bullet_range - body.distance_traveled) / 2
