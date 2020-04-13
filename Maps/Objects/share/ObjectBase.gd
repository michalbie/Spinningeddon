extends StaticBody2D

enum materials {WOOD, STONE, METAL}
export (materials) var object_material

func _on_BulletDeathArea_body_entered(body):
	if get_tree().is_network_server():
		if body.get_filename() == "res://Entities/Bullet/Bullet.tscn" and object_material != materials.WOOD:
			GameManager.world.rpc("delete_bullet", body.get_name())
