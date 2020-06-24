extends Node

func _process(delta):
	if GameManager.in_game and get_tree().is_network_server():
		calculate_bullets(delta)

func _on_input_ready(input):
	rpc_unreliable_id(1, "process_input", input)

remote func process_input(input): 
	calculate_player(get_tree().get_rpc_sender_id(), input)
	
func calculate_player(id, input):
	var player = get_tree().get_root().get_node("World/" + str(id))
	
	if player != null: #after killing the player, he emits one signal idk why and player is null. Only one time
		var player_info = {}
		calculate_player_position(player, input)
		calculate_player_rotation(player, input)
		check_if_player_shoot(player, id, input)
		send_player_info(id, player)
	else:
		print("PLAYER NULL")
		
func calculate_player_position(player, input):
	var direction = input['mouse_pos'] - player.position
	if input['inside_circle'] == false:
		player.move_and_collide(direction.normalized() * player.move_speed * input['delta'])
		SoundManager.rpc("play_moving_sound", player.get_name())
	else:
		player.move_and_collide(Vector2(0, 0))
		SoundManager.rpc("stop_moving_sound", player.get_name())
			
func calculate_player_rotation(player, input):
	if input['switch_rotation'] == true:
		if player.get_node("RotateCooldown").is_stopped() == true:
			player.get_node("RotateCooldown").start(player.rotate_cooldown)
			player.rotate_direction  = -player.rotate_direction
			player.hud.rpc_id(int(player.get_name()), "update_rotate_cooldown", player.get_node("RotateCooldown").wait_time)
			for id in player.observers_list:
				GameManager.world.spectator_system.get_node("HUD").rpc_id(int(id), "update_rotate_cooldown", player.get_node("RotateCooldown").wait_time)
	player.rotate(player.rotate_direction * player.rotate_speed * input['delta'])
	
func check_if_player_shoot(player, id, input):
	if input['shoot'] == true:
		if player.get_node("ShootCooldown").is_stopped() == true:
			player.get_node("ShootCooldown").start(player.shoot_cooldown)
			
			player.hud.rpc_id(int(player.get_name()), "update_shoot_cooldown", player.get_node("ShootCooldown").wait_time)
			for id in player.observers_list:
				GameManager.world.spectator_system.get_node("HUD").rpc_id(int(id), "update_shoot_cooldown", player.get_node("ShootCooldown").wait_time)
				
			if player is Globals.classes["CloseRifleman"]["class"]:
				player.rotate(-player.bullet_spread)
				GameManager.world.rpc("spawn_bullet", id)
				player.rotate(player.bullet_spread)
				GameManager.world.rpc("spawn_bullet", id)
				player.rotate(player.bullet_spread)
				GameManager.world.rpc("spawn_bullet", id)
				player.rotate(-player.bullet_spread)
			elif player is Globals.classes["Soldier"]["class"]:
				GameManager.world.rpc("spawn_bullet", id, true)
			else:
				GameManager.world.rpc("spawn_bullet", id)
			
			player.get_node("Camera2D").rpc_id(int(player.get_name()), "camera_shoot_recoil")
			SoundManager.rpc("play_shoot_sound", player.get_name())
		
func send_player_info(id, player):
	var player_info = {}
	player_info['position'] = player.position
	player_info['body_rotation'] = player.rotation
	GameManager.players_info[id] = player_info
	GameManager.rset_unreliable("players_info", GameManager.players_info)


func calculate_bullets(delta):
	for bullet in GameManager.bullets_info:
		calculate_bullet_state(bullet, delta)
		GameManager.rset_unreliable("bullets_info", GameManager.bullets_info)
		
func calculate_bullet_state(bullet, delta):
	var bullet_instance = GameManager.world.get_node(bullet)
	
	if bullet_instance.distance_traveled < bullet_instance.bullet_range:
		var previous_position = bullet_instance.global_position
		var collision = bullet_instance.move_and_collide(bullet_instance.velocity * bullet_instance.speed * delta)
		
		if collision:
			bullet_instance.handle_collision(collision, collision.collider)
		else:
			var current_postion = bullet_instance.global_position
			var distance_vector = current_postion - previous_position
			bullet_instance.distance_traveled += distance_vector.length()
			GameManager.bullets_info[bullet]["position"] = bullet_instance.global_position
	else:
		GameManager.world.rpc("delete_bullet", bullet_instance.get_name())
