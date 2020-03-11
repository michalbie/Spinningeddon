extends Node

signal player_update_ready(id, player_info)

var GameSession = preload("res://Scenes/World/World.tscn")
var Player = preload("res://Entities/Character/Player/Player.tscn")
var world
var players_info = {}

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
		player.set_name(str(p))
		world.add_child(player)
		player.position = Vector2(randi()%int(get_viewport().size.x), randi()%int(get_viewport().size.y))
		connect("player_update_ready", player, "_on_player_update_ready")
		players_info[p] = {"position": player.position}
		get_tree().change_scene_to(world)
		
func _on_input_ready(input):
	rpc_unreliable_id(1, "process_input", input)
		
remote func process_input(input): #TODO bez sensu ta funkcja. Lepiej przekazywać słownik zamiast zmiennych
	update(get_tree().get_rpc_sender_id(), input)
	
func update(id, input):
	var player = get_tree().get_root().get_node("World/" + str(id))
	var direction = input['mouse_pos'] - player.position
	if input['inside_circle'] == false:
		player.move_and_collide(direction.normalized() * player.move_speed * input['delta'])
	var player_info = {"position": player.position}
	emit_signal("player_update_ready", id, player_info)
