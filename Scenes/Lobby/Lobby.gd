extends Control

#signal start_game

var PlayerLabel = preload("res://Scenes/Lobby/PlayerLabel.tscn")
onready var labels_container = get_node("MarginContainer/VBoxContainer")
onready var scene_tree = get_tree()

func _ready():
	StartGameBtn_configure()

func StartGameBtn_configure():
	if !scene_tree.is_network_server():
		$MarginContainer/StartGameBtn.disabled = true

func add_item(player_name):
	var new_label = PlayerLabel.instance()
	labels_container.add_child(new_label)
	new_label.set_text(player_name)
	
func remove_item(player_name):
	for c in labels_container.get_children():
		if c.text == player_name:
			labels_container.remove_child(c)
			break


func _on_QuitLobbyBtn_pressed():
	scene_tree.change_scene("res://Scenes/MainMenu/MainMenu.tscn")
	LobbyManager.disconnect_from_server(scene_tree.get_network_unique_id())
	queue_free()


func _on_StartGameBtn_pressed():
	print("Start!")
	rpc("initialize_world")
