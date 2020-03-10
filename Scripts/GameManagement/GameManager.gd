extends Node

var GameSession = preload("res://Scenes/World/World.tscn")
var world

remote func initialize_world():
	print("initializing...")
	world = GameSession.instance()
	get_tree().get_root().add_child(world)
	get_tree().change_scene(world)
