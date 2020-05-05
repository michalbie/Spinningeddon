extends Control

func _ready():
	if AudioServer.is_bus_mute(0):
		$MarginContainer/CenterContainer/VBoxContainer/MuteCheckBox.pressed = true
		
	$MarginContainer/CenterContainer/VBoxContainer/VolumeSlider.value = AudioServer.get_bus_volume_db(0)

func _on_BackBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/SubMenus/Settings/Settings.tscn")


func _on_VolumeSlider_value_changed(value):
	var percent_value = value / $MarginContainer/CenterContainer/VBoxContainer/VolumeSlider.max_value
	var new_text = str(int(round(percent_value * 100 + 100))) + "%"
	$MarginContainer/CenterContainer/VBoxContainer/VolumeValue.text =  new_text
	AudioServer.set_bus_volume_db(0, value) #-30 to 30 db range


func _on_MuteCheckBox_pressed():
	if $MarginContainer/CenterContainer/VBoxContainer/MuteCheckBox.pressed == true:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
