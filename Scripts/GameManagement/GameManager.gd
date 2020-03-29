extends Node

var GameSession = preload("res://Scenes/World/World.tscn")
const CLASSES_PATH = "res://Entities/Character/Player/Classes/"
var Lobby = preload("res://Scenes/Lobby/Lobby.tscn")
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
		var picked_class_scene = load(CLASSES_PATH + LobbyManager.players[p]["class"] + ".tscn")
		var player = picked_class_scene.instance()
		player.set_name(str(p))
		world.add_child(player)
		player.position = random_spawnpoint()
		players_info[p] = {"position": player.position, "body_rotation": player.get_node("Body").rotation}
		get_tree().change_scene_to(world)
		
func random_spawnpoint():
	var x_axis = [2054, 750, 3145, 4858, 8208, 11649, 2137, 7730, 5983, 3971, 6275, 9049, 11839, 10444, 9073, 6675, 12331]
	var y_axis = [1510, 5000, 6606, 9790, 10184, 8987, 9001, 7470, 7184, 3498, 1179, 1604, 1826, 4098, 5777, 4295, 6470]
	var number = randi()%17
	return Vector2(x_axis[number], y_axis[number])
		
func update_world():
	update_players()
	update_bullets()
		
func update_players():
	for player_id in players_info:
		world.get_node(str(player_id)).position = players_info[player_id]["position"]
		world.get_node(str(player_id) + "/Body").rotation = players_info[player_id]["body_rotation"]

func update_bullets():
	for bullet in bullets_info:
		if world.get_node(bullet) != null:
			world.get_node(bullet).global_position = bullets_info[bullet]['position']
			world.get_node(bullet + "/Sprite").rotation = bullets_info[bullet]['rotation']

func delete_player(player_name):
	players_info.erase(player_name)
	if players_info.size() < 2:
		end_game()

func end_game():
	in_game = false
	world.visible = false
	bullets_count = 0
	bullets_info.clear()
	players_info.clear()
	world.queue_free()
	LobbyManager.lobby.visible = true
	get_tree().change_scene_to(LobbyManager.lobby)

