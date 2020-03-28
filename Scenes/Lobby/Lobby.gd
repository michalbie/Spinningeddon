extends Control

signal start_game

var PlayerLabel = preload("res://Scenes/Lobby/PlayerLabel.tscn")
onready var labels_container = get_node("MarginContainer/HBoxContainer/VBoxContainer")
onready var scene_tree = get_tree()

func _ready():
	connect("start_game", GameManager, "prepare_game")
	for button in $"MarginContainer/HBoxContainer/ClassesMenu/Classes".get_children():
		button.connect("pressed", self, "_on_class_selected", [button.name])
	StartGameBtn_configure()
	initialize_lobby()
	
func initialize_lobby():
	for id in LobbyManager.players:
		add_item(LobbyManager.players[id]["name"])
	if scene_tree.is_network_server():
		$"MarginContainer/HBoxContainer/ClassesMenu".visible = false

func StartGameBtn_configure():
	$MarginContainer/StartGameBtn.disabled = true

func add_item(player_name):
	var new_label = PlayerLabel.instance()
	labels_container.add_child(new_label)
	new_label.set_text(player_name)
	if scene_tree.is_network_server() and LobbyManager.players.size() >= 2:
		$MarginContainer/StartGameBtn.disabled = false
	
func remove_item(player_name):
	for c in labels_container.get_children():
		if c.text == player_name:
			labels_container.remove_child(c)
			if scene_tree.is_network_server() and LobbyManager.players.size() < 2:
				$MarginContainer/StartGameBtn.disabled = true
			break

remotesync func hide_lobby():
	self.visible = false
	
remotesync func show_lobby():
	self.visible = true

func _on_QuitLobbyBtn_pressed():
	scene_tree.change_scene("res://Scenes/MainMenu/MainMenu.tscn")
	LobbyManager.disconnect_me()

func _on_StartGameBtn_pressed():
	print("Start!")
	rpc("hide_lobby")
	emit_signal("start_game")
	
func _on_class_selected(class_id):
	$"MarginContainer/HBoxContainer/ClassesMenu/TextureRect".texture = load("res://Entities/Character/assets/" + class_id + ".png")
	LobbyManager.players[scene_tree.get_network_unique_id()]["class"] = class_id
	rpc("set_player_class", class_id)
	
remote func set_player_class(class_id):
	LobbyManager.players[scene_tree.get_rpc_sender_id()]["class"] = class_id
