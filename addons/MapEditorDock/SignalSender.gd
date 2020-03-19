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
