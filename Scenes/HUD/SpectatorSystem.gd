extends Node

var HUD = preload("res://Scenes/HUD/HUD.tscn")

var current_observing = 0
remote var current_player_info = {}

func _process(delta):
	listen_camera_switch()

func get_random_camera():
	randomize()
	if GameManager.players_info.size() > 0:
		var random_index = randi() % GameManager.players_info.size()
		current_observing = random_index
		GameManager.world.get_node(str(GameManager.players_info.keys()[random_index])).get_node("Camera2D").make_current()
		GameManager.world.get_node(str(GameManager.players_info.keys()[random_index])).rpc_id(1, "append_observer", get_tree().get_network_unique_id())
		get_player_info()

func listen_camera_switch():
	if GameManager.players_info.size() > 1 and !GameManager.players_info.has(get_tree().get_network_unique_id()) and !get_tree().is_network_server():
		
		if Input.is_action_just_pressed("switch_camera_left"):
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).rpc_id(1, "erase_observer", get_tree().get_network_unique_id())
			
			if current_observing > 0:
				current_observing -= 1
			else:
				current_observing = GameManager.players_info.size() - 1
				
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).get_node("Camera2D").make_current()
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).rpc_id(1, "append_observer", get_tree().get_network_unique_id())
			get_player_info()
			
		if Input.is_action_just_pressed("switch_camera_right"):
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).rpc_id(1, "erase_observer", get_tree().get_network_unique_id())
			
			if current_observing < GameManager.players_info.size() - 1:
				current_observing += 1
			else:
				current_observing = 0
				
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).get_node("Camera2D").make_current()
			GameManager.world.get_node(str(GameManager.players_info.keys()[current_observing])).rpc_id(1, "append_observer", get_tree().get_network_unique_id())
			get_player_info()

func get_player_info():
	GameManager.world.spectator_system.rpc_id(1, "send_player_info", get_tree().get_network_unique_id(), GameManager.players_info.keys()[current_observing])
	
remote func send_player_info(receiver_id, player_id):
	print("SEND_PLAYER_INFO...")
	var info = {}
	info['max_hp'] = GameManager.world.get_node(str(player_id)).max_hp
	info['hp'] = GameManager.world.get_node(str(player_id)).hp
	print(receiver_id)
	print(player_id)
	print(info)
	GameManager.world.spectator_system.rset_id(receiver_id, "current_player_info", info)
	GameManager.world.spectator_system.rpc_id(receiver_id, "test_print", info)
	GameManager.world.spectator_system.rpc_id(receiver_id, "set_new_hud", info)
	
remote func test_print(info):
	print(info)
	
remote func set_new_hud(info):
	print(current_player_info)
	print(info)
	$HUD.initialize_with_parameters(info['max_hp'], info['hp'])
