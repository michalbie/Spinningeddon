extends Node

signal player_update_ready(id, player_info)

var GameSession = preload("res://Scenes/World/World.tscn")
var Player = preload("res://Entities/Character/Player/Player.tscn")
var Bullet = preload("res://Entities/Bullet/Bullet.tscn")
var world
remotesync var in_game = false

remote var players_info = {}
remote var bullets_info = {}
remote var bullets_count = 0


func _physics_process(delta):
	if in_game:
		update_world()

func prepare_game():
	randomize()
	rpc("initialize_world")
	rpc("initialize_players")
	rset("in_game", true)

remotesync func initialize_world():
	print("initializing world...")
	world = GameSession.instance()
	get_tree().get_root().add_child(world)
	get_tree().change_scene_to(world)

remotesync func initialize_players():
	print("initializing players...")
	for p in LobbyManager.players:
		var player = Player.instance()
		player.set_name(str(p))
		world.add_child(player)
		player.position = Vector2(randi()%int(get_viewport().size.x), randi()%int(get_viewport().size.y))
		players_info[p] = {"position": player.position, "body_rotation": player.get_node("Body").rotation}
		get_tree().change_scene_to(world)
		
func update_world():
	update_players()
	update_bullets()
		
func update_players():
	for player_id in players_info:
		world.get_node(str(player_id)).position = players_info[player_id]["position"]
		world.get_node(str(player_id) + "/Body").rotation = players_info[player_id]["body_rotation"]

func update_bullets():
	for bullet in bullets_info:
		world.get_node(bullet).global_position = bullets_info[bullet]['position']


remotesync func spawn_bullet(player_id):
	var bullet = Bullet.instance()
	var player = world.get_node(str(player_id))
	bullet.set_name("bullet" + str(bullets_count))
	world.add_child(bullet)
	bullet.global_position = player.get_node("Body/Rifle/Bullet_spawn").global_position
	bullet.init(player.bullet_speed, player.bullet_damage, 
				Vector2(0, -1).rotated(player.get_node("Body").rotation), 
				player.get_node("Body").rotation, player.bullet_range)
	bullets_info[bullet.get_name()] = {"position": bullet.global_position}
	bullets_count += 1
	
remotesync func delete_bullet(bullet_name):
	if world.get_node(bullet_name).exist == true:
		world.get_node(bullet_name).exist = false
		bullets_info.erase(bullet_name)

		print("Actual world's children: ")
		for child in world.get_children():
			print(child.get_name())
		print('---------------------------')
		print("Deleting: " + bullet_name)
		print('---------------------------')
		print('---------------------------')
		world.get_node(bullet_name).queue_free()
		world.remove_child(world.get_node(bullet_name))
