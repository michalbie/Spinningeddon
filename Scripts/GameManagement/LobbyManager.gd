extends Node

var Player = preload("res://Entities/Character/Player/Player.tscn")
var lobby

const PORT = 2137
const LOBBY_SIZE = 5

var players = {}
var my_name
var server_ip


func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, LOBBY_SIZE)
	get_tree().set_network_peer(peer)
	peer.connect("peer_connected", self, "_on_peer_connected")
	peer.connect("peer_disconnected", self, "_on_peer_disconnected")
	create_lobby()
	
func create_client():
	var peer = NetworkedMultiplayerENet.new()
	get_tree().connect("connection_failed", self, "onConFail")
	peer.create_client(server_ip, PORT)
	get_tree().set_network_peer(peer)
	peer.connect("peer_connected", self, "_on_peer_connected")
	peer.connect("peer_disconnected", self, "_on_peer_disconnected")
	create_lobby()
		
func onConFail():
	print("skkkkkk")

func _on_peer_connected(id):
	rpc_id(id, "register_player", my_name)
	
func _on_peer_disconnected(id):
	unregister_player(players[id])
	
remote func register_player(new_player_name):
	var id = get_tree().get_rpc_sender_id()
	players[id] = new_player_name
	
	if id != 1: #for client screen
		lobby.add_item(new_player_name)

func unregister_player(id):
	lobby.remove_item(id)
	players.erase(id)
	
func create_lobby():
	var Lobby = load("res://Scenes/Lobby/Lobby.tscn")
	lobby = Lobby.instance()
	add_child(lobby)
	get_tree().change_scene_to(lobby)
	
	if get_tree().get_network_unique_id() != 1: #for server screen
		lobby.add_item(my_name)
	

#Client code here v


