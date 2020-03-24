extends Node2D

func _on_Area_body_exited(body):
	if "distance_traveled" in body:
		body.distance_traveled += (body.bullet_range - body.distance_traveled) / 2
