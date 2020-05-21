extends "res://Maps/Objects/share/ObjectBase.gd"

func _on_Area_body_exited(body):
	if "distance_traveled" in body:
		body.distance_traveled += (body.bullet_range - body.distance_traveled) / 2
		SoundManager.rpc("play_penetrate_sound", self.get_name())
