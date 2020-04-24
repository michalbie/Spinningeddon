extends Node


remote func play_moving_sound(player_name):
	if !GameManager.world.get_node(player_name + "/Sounds/MovingSound").playing and get_tree().get_network_unique_id() != int(player_name):
		GameManager.world.get_node(player_name + "/Sounds/MovingSound").play()
		
remote func stop_moving_sound(player_name):
	GameManager.world.get_node(player_name + "/Sounds/MovingSound").stop()

remotesync func play_shoot_sound(player_name):
	GameManager.world.get_node(player_name + "/Sounds/ShootSound").play()

