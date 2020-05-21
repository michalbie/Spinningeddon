extends Control

signal start_game

var PlayerLabel = preload("res://Scenes/Lobby/PlayerLabel.tscn")
onready var labels_container = get_node("MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer")
onready var scene_tree = get_tree()

func _ready():
	connect("start_game", GameManager, "prepare_game")
	for section in $"MarginContainer/VBoxContainer/ClassesMenu/".get_children():
		section.get_node("Button").connect("pressed", self, "_on_class_selected", [section.name])
	PlayerReadyBtn_configure()
	initialize_lobby()
	
func initialize_lobby():
	for id in LobbyManager.players:
		add_item(LobbyManager.players[id]["name"])
	if scene_tree.is_network_server():
		$MarginContainer/VBoxContainer/ClassesMenu.visible = false
		$MarginContainer/VBoxContainer/TopBar/GameStatus.visible = false
	else:
		_on_class_selected("Soldier")
		
	if LobbyManager.server_status == false:
		$MarginContainer/VBoxContainer/TopBar/GameStatus.visible = false
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/ReadyContainer/PlayerReadyBtn.disabled = true

func PlayerReadyBtn_configure():
	if scene_tree.is_network_server():
		$MarginContainer/VBoxContainer/HBoxContainer/ReadyContainer/PlayerReadyBtn.visible = false

func add_item(player_name):
	var new_label = PlayerLabel.instance()
	labels_container.add_child(new_label)
	new_label.set_text(player_name)

func remove_item(player_name):
	for c in labels_container.get_children():
		if c.get_node("Label").text == player_name:
			labels_container.remove_child(c)
			break

remotesync func hide_lobby():
	self.visible = false
	
remotesync func show_lobby():
	self.visible = true


func _on_PlayerReadyBtn_pressed():
	for button in $"MarginContainer/VBoxContainer/ClassesMenu".get_children():
		button.get_node("Button").disabled = true
	$MarginContainer/VBoxContainer/HBoxContainer/ReadyContainer/PlayerReadyBtn.disabled = true
	rpc_id(1, "_on_player_ready")
	
func _on_class_selected(class_id):
	for section in $"MarginContainer/VBoxContainer/ClassesMenu".get_children():
		section.get_node("ClassSelection").visible = false
		
	get_node("MarginContainer/VBoxContainer/ClassesMenu/" + class_id).get_node("ClassSelection").visible = true
	LobbyManager.players[scene_tree.get_network_unique_id()]["class"] = class_id
	rpc("set_player_class", class_id)

	
remote func set_player_class(class_id):
	LobbyManager.players[scene_tree.get_rpc_sender_id()]["class"] = class_id
	
remote func update_game_status():
	$MarginContainer/VBoxContainer/TopBar/GameStatus.visible = false
	$MarginContainer/VBoxContainer/HBoxContainer/ReadyContainer/PlayerReadyBtn.disabled = false
	
remote func _on_player_ready():
	LobbyManager.players[scene_tree.get_rpc_sender_id()]["is_ready"] = true
	for player in LobbyManager.players:
		if !LobbyManager.players[player]["is_ready"]:
			return
	if LobbyManager.players.size() >= 1:
		rpc("hide_lobby")
		emit_signal("start_game")
	
func reset_to_default():
	for player in LobbyManager.players:
		LobbyManager.players[player]["is_ready"] = false
	for button in $"MarginContainer/VBoxContainer/ClassesMenu".get_children():
		button.get_node("Button").disabled = false
	$"MarginContainer/VBoxContainer/HBoxContainer/ReadyContainer/PlayerReadyBtn".disabled = false


func _on_ReturnButton_pressed():
	scene_tree.change_scene("res://Scenes/MainMenu/MainMenu.tscn")
	LobbyManager.disconnect_me()
