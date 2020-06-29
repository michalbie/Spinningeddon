extends Area2D

func _on_Healthpack_body_entered(body):
	if body.has_method("got_shot"):
		body.got_shot(-50, "Game", null)
		GameManager.world.rpc("delete_healthpack", self.get_name())
