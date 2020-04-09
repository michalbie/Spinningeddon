extends CanvasLayer

func initialize():
	$Control/MarginContainer/HBoxContainer/TextureProgress.max_value = GameManager.world.get_node(str(get_tree().get_network_unique_id())).hp
	$Control/MarginContainer/HBoxContainer/TextureProgress.value = GameManager.world.get_node(str(get_tree().get_network_unique_id())).hp
	
remote func update_hp(new_hp):
	$Control/MarginContainer/HBoxContainer/TextureProgress.set_value(new_hp)
