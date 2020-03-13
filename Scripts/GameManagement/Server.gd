extends Node

var Bullet = preload("res://Entities/Bullet/Bullet.tscn")

func _process(delta):
	if GameManager.in_game and get_tree().is_network_server():
		calculate_bullets(delta)

func _on_input_ready(input):
	rpc_unreliable_id(1, "process_input", input)

remote func process_input(input): #TODO bez sensu ta funkcja. Lepiej przekazywać słownik zamiast zmiennych
	calculate_players(get_tree().get_rpc_sender_id(), input)
	
	
func calculate_players(id, input):
	var player = get_tree().get_root().get_node("World/" + str(id))
	
	var direction = input['mouse_pos'] - player.position
	if input['inside_circle'] == false:
		player.move_and_collide(direction.normalized() * player.move_speed * input['delta'])

	if input['switch_rotation'] == true:
		if player.get_node("RotateCooldown").is_stopped() == true:
			player.get_node("RotateCooldown").start(player.rotate_cooldown)
			player.rotate_direction  = -player.rotate_direction
	player.get_node("Body").rotate(player.rotate_direction * player.rotate_speed * input['delta'])

	if input['shoot'] == true:
		print(str(input['shoot']) + " for " + str(id))
		player.rset_id(id, "shoot", false)
		GameManager.rpc("spawn_bullet", id)
	
	var player_info = {}
	player_info['position'] = player.position
	player_info['body_rotation'] = player.get_node("Body").rotation
	
	GameManager.players_info[id] = player_info
	GameManager.rset_unreliable("players_info", GameManager.players_info)
	
	
func calculate_bullets(delta):
	for bullet in GameManager.bullets_info:
		var bullet_instance = GameManager.world.get_node(bullet)
		
		if bullet_instance.distance_traveled < bullet_instance.bullet_range:
			var previous_position = bullet_instance.global_position
			bullet_instance.move_and_collide(bullet_instance.velocity * bullet_instance.speed * delta)
			var collision = bullet_instance.move_and_collide(bullet_instance.velocity * bullet_instance.speed * delta)
			
			if collision:
				print("collided")
				GameManager.rpc("delete_bullet", bullet_instance.get_name())
			else:
				var current_postion = bullet_instance.global_position
				var distance_vector = current_postion - previous_position
				bullet_instance.distance_traveled += distance_vector.length()
				GameManager.bullets_info[bullet]["position"] = bullet_instance.global_position
		
		else:
			print("Distance travelled")
			GameManager.rpc("delete_bullet", bullet_instance.get_name())
			
		GameManager.rset_unreliable("bullets_info", GameManager.bullets_info)
