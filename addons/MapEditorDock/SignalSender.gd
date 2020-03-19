tool
extends Control

signal button_pressed(sender)

func _ready():
	for child in get_node("VBoxContainer").get_children():
		child.get_node("Label").text = child.title

func _on_WoodWallBtn_pressed():
	emit_signal("button_pressed", "WoodWall")


func _on_ConcreteWallBtn_pressed():
	emit_signal("button_pressed", "ConcreteWall")


func _on_StoneWallBtn_pressed():
	emit_signal("button_pressed", "StoneWall")


func _on_BricksWallBtn_pressed():
	emit_signal("button_pressed", "BricksWall")


func _on_MetalWallBtn_pressed():
	emit_signal("button_pressed", "MetalWall")


func _on_Roof1_pressed():
	emit_signal("button_pressed", "Roof1")


func _on_Roof2_pressed():
	emit_signal("button_pressed", "Roof2")


func _on_Roof3_pressed():
	emit_signal("button_pressed", "Roof3")


func _on_Roof4_pressed():
	emit_signal("button_pressed", "Roof4")


func _on_Roof5_pressed():
	emit_signal("button_pressed", "Roof5")


func _on_Roof6_pressed():
	emit_signal("button_pressed", "Roof6")


func _on_Road1_pressed():
	emit_signal("button_pressed", "Road1")


func _on_Road2_pressed():
	emit_signal("button_pressed", "Road2")


func _on_Sidewalk_pressed():
	emit_signal("button_pressed", "Sidewalk")
	
	
func _on_Rock_pressed():
	emit_signal("button_pressed", "Rock")


func _on_Tree_pressed():
	emit_signal("button_pressed", "Tree")
