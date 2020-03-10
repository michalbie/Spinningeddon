extends Node

var GameSession = preload("res://Scenes/World/World.tscn")
var Player = preload("res://Entities/Character/Player/Player.tscn")
var world
var player_info = {}

func prepare_game():
	randomize()
	rpc("initialize_world")
	rpc("initialize_players")

remotesync func initialize_world():
	print("initializing world...")
	world = GameSession.instance()
	get_tree().get_root().add_child(world)
	get_tree().change_scene_to(world)

remotesync func initialize_players():
	print("initializing players...")
	for p in LobbyManager.players:
		var player = Player.instance()
		player.set_name(p)
		player.global_position = Vector2(randi()%int(get_viewport().size.x), randi()%int(get_viewport().size.y))
		player_info[p] = {"position": player.global_position}
		world.add_child(player)
		get_tree().change_scene_to(world)
