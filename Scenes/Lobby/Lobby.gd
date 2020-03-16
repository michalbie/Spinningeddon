extends Control

signal start_game

var PlayerLabel = preload("res://Scenes/Lobby/PlayerLabel.tscn")
onready var labels_container = get_node("MarginContainer/VBoxContainer")
onready var scene_tree = get_tree()

func _ready():
	connect("start_game", GameManager, "prepare_game")
	StartGameBtn_configure()
	initialize_lobby()
	
func initialize_lobby():
	for id in LobbyManager.players:
		add_item(LobbyManager.players[id])

func StartGameBtn_configure():
	$MarginContainer/StartGameBtn.disabled = true

func add_item(player_name):
	var new_label = PlayerLabel.instance()
	labels_container.add_child(new_label)
	new_label.set_text(player_name)
	if scene_tree.is_network_server() and labels_container.get_child_count() > 1:
		$MarginContainer/StartGameBtn.disabled = false
	
func remove_item(player_name):
	for c in labels_container.get_children():
		if c.text == player_name:
			labels_container.remove_child(c)
			if scene_tree.is_network_server() and labels_container.get_child_count() < 2:
				$MarginContainer/StartGameBtn.disabled = true
			break

remotesync func hide_lobby():
	self.visible = false
	
remotesync func show_lobby():
	print("Lobby shown!")
	self.visible = true

func _on_QuitLobbyBtn_pressed():
	scene_tree.change_scene("res://Scenes/MainMenu/MainMenu.tscn")
	LobbyManager.disconnect_me()

func _on_StartGameBtn_pressed():
	print("Start!")
	rpc("hide_lobby")
	emit_signal("start_game")
	
	