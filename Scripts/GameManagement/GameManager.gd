extends Node

var GameSession = preload("res://Scenes/World/World.tscn")
const CLASSES_PATH = "res://Entities/Character/Player/Classes/"
var Lobby = preload("res://Scenes/Lobby/Lobby.tscn")
var world
var occupied_spawnpoints = []

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
	var cords = [[2054, 1510], [6444, 10348], [10576, 10283], [4092, 5202], [750, 5000], [3145, 6606], [4858, 9790], [8208, 10184], [11649, 8987], [2137, 9001], [7730, 7470], [5983, 7184], [3971, 3498], [6275, 1179], [9049, 1604], [11839, 1826], [10444, 4098], [9073, 5777], [6675, 4295], [12331, 6470]]
	while true:
		var number = randi() % cords.size()
		if occupied_spawnpoints.has(number):
			continue
		else:
			occupied_spawnpoints.append(number)
			return Vector2(cords[number][0], cords[number][1])
		
func update_world():
	update_players()
	update_bullets()
		
func update_players():
	for player_id in players_info:
		if world.get_node(str(player_id)) != null:
			world.get_node(str(player_id)).position = players_info[player_id]["position"]
			world.get_node(str(player_id)).rotation = players_info[player_id]["body_rotation"]

func update_bullets():
	for bullet in bullets_info:
		if world.get_node(bullet) != null:
			world.get_node(bullet).global_position = bullets_info[bullet]['position']
			world.get_node(bullet).rotation = bullets_info[bullet]['rotation']

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

