extends Control


func _on_BackBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_SoundBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/SubMenus/Settings/Sound/SoundSettings.tscn")
