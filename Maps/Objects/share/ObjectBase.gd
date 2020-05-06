extends StaticBody2D

enum materials {WOOD, STONE, METAL}
export (materials) var object_material

func _on_BulletDeathArea_body_entered(body):
	if get_tree().is_network_server():
		if body.get_filename() == "res://Entities/Bullet/Bullet.tscn" and object_material != materials.WOOD:
			GameManager.world.rpc("delete_bullet", body.get_name())
			
		elif body.get_filename() == "res://Entities/Bullet/SoldierBullet.tscn":
			body.distance_traveled += (body.bullet_range - body.distance_traveled) / 2
			SoundManager.rpc("play_penetrate_sound", self.get_name())

