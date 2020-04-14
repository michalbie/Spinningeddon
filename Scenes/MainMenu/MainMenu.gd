extends CanvasLayer

signal create_server_pressed

func _ready():
	connect("create_server_pressed", LobbyManager, "create_server")

func _on_JoinGameBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/JoinMenu.tscn")

func _on_CreateServerBtn_pressed():
	LobbyManager.my_name = "Serwer"
	emit_signal("create_server_pressed")
