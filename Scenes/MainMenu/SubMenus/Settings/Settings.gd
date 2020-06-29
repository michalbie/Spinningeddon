extends Control

onready var mute_box = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/HBoxContainer/MuteCheckBox")
onready var volume_slider = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/VolumeSlider")
onready var mute_label = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/HBoxContainer/MuteLabel")

func _ready():
	if AudioServer.is_bus_mute(0):
		mute_label.text = "yes"
		mute_box.pressed = true
		
	volume_slider.value = AudioServer.get_bus_volume_db(0)


func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value) #-30 to 30 db range


func _on_MuteCheckBox_pressed():
	if mute_box.pressed == true:
		AudioServer.set_bus_mute(0, true)
		mute_label.text = "yes"
	else:
		AudioServer.set_bus_mute(0, false)
		mute_label.text = "no"


func _on_ReturnButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")
