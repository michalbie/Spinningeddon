extends Node

var Player = preload("res://Entities/Character/Player/Player.tscn")

var lobby
var peer
onready var scene_tree = get_tree()

const PORT = 2137
const LOBBY_SIZE = 5

var players = {}
var my_name
var server_ip


func create_server():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, LOBBY_SIZE)
	scene_tree.set_network_peer(peer)
	peer.connect("peer_connected", self, "_on_peer_connected")
	peer.connect("peer_disconnected", self, "_on_peer_disconnected")
	create_lobby()
	
func create_client():
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(server_ip, PORT)
	scene_tree.set_network_peer(peer)
	peer.connect("peer_connected", self, "_on_peer_connected")
	peer.connect("peer_disconnected", self, "_on_peer_disconnected")
	peer.connect("connection_succeeded", self, "_on_connection_succeeded")
	
	
func _on_peer_connected(id):
	print("Connected" + str(id))
	if !get_tree().is_network_server():
		players[id] = my_name
		print("Players: " + str(players))
		rpc_id(id, "register_player", my_name)
	
func _on_connection_succeeded():
	if !get_tree().is_network_server():
		players[get_tree().get_network_unique_id()] = my_name
		print("Players: " + str(players))
	create_lobby()
	
func _on_peer_disconnected(id):
	unregister_player(players[id])
	
remote func register_player(new_player_name):
	var sender_id = scene_tree.get_rpc_sender_id()
	players[sender_id] = new_player_name
	
	if sender_id != 1: #for client screen
		lobby.add_item(new_player_name)

func unregister_player(id):
	lobby.remove_item(id)
	players.erase(id)
	
func create_lobby():
	var Lobby = load("res://Scenes/Lobby/Lobby.tscn")
	lobby = Lobby.instance()
	add_child(lobby)
	scene_tree.change_scene_to(lobby)
	
	if !scene_tree.is_network_server(): #for server screen
		lobby.add_item(my_name)

remote func disconnect_from_server(id): #refactorize gt sender rpc id 
	if scene_tree.is_network_server():
		if id != 1:
			scene_tree.get_network_peer().disconnect_peer(id, true)
		else:
			scene_tree.network_peer = null #when server quits the lobby its removing server
	else:
		rpc_id(1, "disconnect_from_server", scene_tree.get_network_unique_id())

