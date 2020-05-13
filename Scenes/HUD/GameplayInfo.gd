extends CanvasLayer

var KillLabel = preload("res://Scenes/HUD/share/KillLabel.tscn")
var PlayerLabel = preload("res://Entities/Character/Player/PlayerName.tscn")

var labels_loaded = false

func _input(event):
	if Input.is_action_just_pressed("show_list"):
		find_node("Control").visible = true
	if Input.is_action_just_released("show_list"):
		find_node("Control").visible = false

func _physics_process(delta):
	if labels_loaded:
		for p in GameManager.players_info:
			var player_label = GameManager.world.get_node("label_" + str(p))
			var label_offset = player_label.get_node("Background/Name").get_rect().size.x / 2
			player_label.position = GameManager.players_info[p]["position"] - Vector2(label_offset, 50)

remote func update_kills_info(killer, victim):
	var killer_name = str(killer)
	if str(killer) != "Fog":
		killer_name = LobbyManager.players[int(killer)]["name"]
	var victim_name = LobbyManager.players[int(victim)]["name"]
	var new_label = KillLabel.instance()
	get_node("MarginContainer/HBoxContainer/KillingsContainer").add_child(new_label)
	new_label.get_node("Label").set_text(str(killer_name) + " killed " + str(victim_name))
	new_label.visible = true


func create_labels():
	for p in LobbyManager.players:
		var player_label = PlayerLabel.instance()
		player_label.set_name("label_" + str(p))
		player_label.get_node("Background/Name").text = LobbyManager.players[p]["name"]
		GameManager.world.add_child(player_label)
	labels_loaded = true
