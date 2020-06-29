extends CanvasLayer


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$Settings.visible = !$Settings.visible
	


func _on_Button_pressed():
	var player = GameManager.world.get_node(str(get_tree().get_network_unique_id()))
	player.got_shot(player.hp, "Heart attack")
	GameManager.end_game()
	LobbyManager.lobby._on_ReturnButton_pressed()
	
