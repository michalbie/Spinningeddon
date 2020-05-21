extends CanvasLayer

signal create_server_pressed

func _ready():
	connect("create_server_pressed", LobbyManager, "create_server")

func _on_JoinGameBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/SubMenus/JoinMenu/JoinMenu.tscn")

func _on_CreateServerBtn_pressed():
	LobbyManager.my_name = "Serwer"
	emit_signal("create_server_pressed")

func _on_SettingsBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/SubMenus/Settings/Settings.tscn")

func _on_ExitBtn_pressed():
	get_tree().quit()
