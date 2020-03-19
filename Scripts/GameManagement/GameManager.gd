extends Node

var GameSession = preload("res://Scenes/World/World.tscn")
var Player = preload("res://Entities/Character/Player/Player.tscn")
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
		world.get_node(bullet + "/Sprite").rotation = bullets_info[bullet]['rotation']

