extends Control

var PlayerLabel = preload("res://Scenes/Lobby/PlayerLabel.tscn")
onready var parent_container = get_node("MarginContainer/VBoxContainer")

func add_item(player_name):
	var new_label = PlayerLabel.instance()
	parent_container.add_child(new_label)
	new_label.set_text(player_name)
	
func remove_item(player_name):
	for c in parent_container.get_children():
		if c.text == player_name:
			parent_container.remove_child(c)
			break
