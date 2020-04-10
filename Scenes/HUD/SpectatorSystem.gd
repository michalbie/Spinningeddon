extends Node2D

var current_observing = 0

func _process(delta):
	listen_camera_switch()

func get_random_camera():
	randomize()
	if GameManager.players_info.size() > 0:
		var random_index = randi() % GameManager.players_info.size()
		current_observing = random_index
		GameManager.world.get_node(str(GameManager.players_info.keys()[random_index])).get_node("Camera2D").make_current()
		GameManager.world.get_node(str(GameManager.players_info.keys()[random_index])).observers_list.append(get_tree().get_network_unique_id())


func listen_camera_switch():
	if GameManager.players_info.size() > 1 and !GameManager.players_info.has(get_tree().get_network_unique_id()):
		if Input.is_action_just_pressed("switch_camera_left"):
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).observers_list.erase(get_tree().get_network_unique_id())
			if current_observing > 0:
				current_observing -= 1
			else:
				current_observing = GameManager.players_info.size() - 1
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).get_node("Camera2D").make_current()
			
		if Input.is_action_just_pressed("switch_camera_right"):
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).observers_list.erase(get_tree().get_network_unique_id())
			if current_observing < GameManager.players_info.size() - 1:
				current_observing += 1
			else:
				current_observing = 0
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).get_node("Camera2D").make_current()
