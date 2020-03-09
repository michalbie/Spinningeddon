extends Control

var PlayerLabel = preload("res://Scenes/Lobby/PlayerLabel.tscn")

func add_item(player_name):
	var new_label = PlayerLabel.instance()
	get_node("MarginContainer/VBoxContainer").add_child(new_label)
	new_label.set_text(player_name)
