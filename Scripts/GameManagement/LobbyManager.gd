extends Node

var lobby
var peer
onready var scene_tree = get_tree()

const PORT = 48468 #2137
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
	peer.connect("peer_disconnected", self, "_on_peer_disconnected")
	peer.connect("connection_succeeded", self, "_on_connection_succeeded")
	
	
func _on_peer_connected(id):
	print("Connected: " + str(id))
	
func _on_connection_succeeded():
	rpc_id(1, "register_new_player", scene_tree.get_network_unique_id(), my_name)
	
remote func register_new_player(new_id, new_player_name):
	players[new_id] = {"name": new_player_name, "class": "Soldier"}
	lobby.add_item(players[new_id]["name"])
	rpc("update_players_lobby", new_id, players)
	
func _on_peer_disconnected(id):
	unregister_player(id)
	if GameManager.in_game:
		GameManager.player_died(id)
	
remote func update_players_lobby(new_player_id, players_list):
	players = players_list
	if new_player_id == scene_tree.get_network_unique_id():
		create_lobby()
	else:
		lobby.add_item(players[new_player_id]["name"])

func unregister_player(id):
	lobby.remove_item(players[id]["name"])
	players.erase(id)
	
func create_lobby():
	var Lobby = load("res://Scenes/Lobby/Lobby.tscn")
	lobby = Lobby.instance()
	add_child(lobby)
	scene_tree.change_scene_to(lobby)

func disconnect_me(): #refactorize gt sender rpc id 
	scene_tree.network_peer.close_connection()
	scene_tree.network_peer = null
	players.clear()
	remove_child(lobby)
