extends CanvasLayer

var KillLabel = preload("res://Scenes/HUD/share/KillLabel.tscn")

remote func update_killings(killer, victim):
	var killer_name = str(killer)
	if str(killer) != "Fog":
		killer_name = LobbyManager.players[int(killer)]["name"]
	var victim_name = LobbyManager.players[int(victim)]["name"]
	var new_label = KillLabel.instance()
	get_node("MarginContainer/HBoxContainer/KillingsContainer").add_child(new_label)
	new_label.set_text(str(killer_name) + " killed " + str(victim_name))
	new_label.visible = true
