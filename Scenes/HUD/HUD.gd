extends CanvasLayer


func initialize():
	$Control/MarginContainer/HBoxContainer/TextureProgress.max_value = GameManager.world.get_node(str(get_tree().get_network_unique_id())).hp
	$Control/MarginContainer/HBoxContainer/TextureProgress.value = GameManager.world.get_node(str(get_tree().get_network_unique_id())).hp
	
func initialize_with_parameters(max_val, val, kills):
	$Control/MarginContainer/HBoxContainer/TextureProgress.max_value = max_val
	$Control/MarginContainer/HBoxContainer/TextureProgress.value = val
	$Control/MarginContainer/KillsCounter.text = "Kills: " + str(kills)
	
remote func update_hp(new_hp):
	$Control/MarginContainer/HBoxContainer/TextureProgress.set_value(new_hp)

remote func update_kills(kills):
	$Control/MarginContainer/KillsCounter.text = "Kills: " + str(kills)
