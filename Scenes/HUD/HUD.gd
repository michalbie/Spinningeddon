extends CanvasLayer


func initialize():
	$Control/MarginContainer/VBoxContainer/HpBar.max_value = GameManager.world.get_node(str(get_tree().get_network_unique_id())).hp
	$Control/MarginContainer/VBoxContainer/HpBar.value = GameManager.world.get_node(str(get_tree().get_network_unique_id())).hp
	var players_alive_text = str(GameManager.players_alive) + " / " + str(GameManager.players_on_the_beginning)
	$Control/MarginContainer/HBoxContainer/VBoxContainer/PlayersAliveBar/MarginContainer/VBoxContainer/PlayersAliveLabel.set_text(players_alive_text)
	
func initialize_with_parameters(max_val, val, kills):
	$Control/MarginContainer/VBoxContainer/HpBar.max_value = max_val
	$Control/MarginContainer/VBoxContainer/HpBar.value = val
	$Control/MarginContainer/HBoxContainer/VBoxContainer/KillsBar/KillsCounter.text = "Kills " + str(kills)
	var players_alive_text = str(GameManager.players_alive) + " / " + str(GameManager.players_on_the_beginning)
	$Control/MarginContainer/HBoxContainer/VBoxContainer/PlayersAliveBar/MarginContainer/VBoxContainer/PlayersAliveLabel.set_text(players_alive_text)

remote func update_hp(new_hp):
	$Control/MarginContainer/VBoxContainer/HpBar.set_value(new_hp)
	
remote func update_rotate_cooldown(cooldown_time):
	$Control/MarginContainer/VBoxContainer/RotateBar.set_value(0)
	var tween = Tween.new()
	tween.interpolate_property($Control/MarginContainer/VBoxContainer/RotateBar, "value",
	0, 100, cooldown_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	add_child(tween)
	tween.start()
	
remote func update_shoot_cooldown(cooldown_time):
	$Control/MarginContainer/VBoxContainer/ShootBar.set_value(0)
	var tween = Tween.new()
	tween.interpolate_property($Control/MarginContainer/VBoxContainer/ShootBar, "value",
	0, 100, cooldown_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	add_child(tween)
	tween.start()
	
remote func update_players_alive():
	var label = $Control/MarginContainer/HBoxContainer/VBoxContainer/PlayersAliveBar/MarginContainer/VBoxContainer/PlayersAliveLabel
	GameManager.players_alive -= 1
	var new_text = str(GameManager.players_alive) + " / " + str(GameManager.players_on_the_beginning)
	label.set_text(new_text)
	

remote func update_kills(kills):
	$Control/MarginContainer/HBoxContainer/VBoxContainer/KillsBar/KillsCounter.text = "Kills: " + str(kills)

func remove_tween(tween):
	tween.queue_free()
