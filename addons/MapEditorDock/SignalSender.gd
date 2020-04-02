tool
extends Control

signal button_pressed(sender)

func _ready():
	for child in get_node("ScrollContainer/VBoxContainer").get_children():
		child.get_node("Label").text = child.title

func _on_WoodWallBtn_pressed():
	emit_signal("button_pressed", "Walls/WoodWall")


func _on_ConcreteWallBtn_pressed():
	emit_signal("button_pressed", "Walls/ConcreteWall")


func _on_StoneWallBtn_pressed():
	emit_signal("button_pressed", "Walls/StoneWall")


func _on_BricksWallBtn_pressed():
	emit_signal("button_pressed", "Walls/BricksWall")


func _on_MetalWallBtn_pressed():
	emit_signal("button_pressed", "Walls/MetalWall")


func _on_Roof1_pressed():
	emit_signal("button_pressed", "Roofs/Roof1")


func _on_Roof2_pressed():
	emit_signal("button_pressed", "Roofs/Roof2")


func _on_Roof3_pressed():
	emit_signal("button_pressed", "Roofs/Roof3")


func _on_Roof4_pressed():
	emit_signal("button_pressed", "Roofs/Roof4")


func _on_Roof5_pressed():
	emit_signal("button_pressed", "Roofs/Roof5")


func _on_Roof6_pressed():
	emit_signal("button_pressed", "Roofs/Roof6")


func _on_Road1_pressed():
	emit_signal("button_pressed", "Roads/Road1")


func _on_Road2_pressed():
	emit_signal("button_pressed", "Roads/Road2")


func _on_Road2bend_pressed():
	emit_signal("button_pressed", "Roads/Road2Bend")


func _on_Sidewalk_pressed():
	emit_signal("button_pressed", "Miscellaneous/Sidewalk")
	
	
func _on_Rock_pressed():
	emit_signal("button_pressed", "Miscellaneous/Rock")


func _on_Tree_pressed():
	emit_signal("button_pressed", "Miscellaneous/Tree")


func _on_MetalFence_pressed():
	emit_signal("button_pressed", "Walls/MetalFence")


func _on_CafeteriaRoof_pressed():
	emit_signal("button_pressed", "Roofs/CafeteriaRoof")


func _on_CpnRoof_pressed():
	emit_signal("button_pressed", "Roofs/CpnRoof")


func _on_CinemaRoof_pressed():
	emit_signal("button_pressed", "Roofs/CinemaRoof")

func _on_BlockRoof_pressed():
	emit_signal("button_pressed", "Roofs/BlockRoof")

func _on_Chimney_pressed():
	emit_signal("button_pressed", "LargeObjects/Chimney")


func _on_FuelDispatcher_pressed():
	emit_signal("button_pressed", "Miscellaneous/FuelDispatcher")


func _on_Gatehouse_pressed():
	emit_signal("button_pressed", "Miscellaneous/Gatehouse")


func _on_Lamp_pressed():
	emit_signal("button_pressed", "Miscellaneous/Lamp")


func _on_Monument_pressed():
	emit_signal("button_pressed", "LargeObjects/Monument")


func _on_PlayingField_pressed():
	emit_signal("button_pressed", "LargeObjects/PlayingField")


func _on_RedCar_pressed():
	emit_signal("button_pressed", "Vehicles/RedCar")


func _on_YellowCar_pressed():
	emit_signal("button_pressed", "Vehicles/YellowCar")


func _on_GrayCar_pressed():
	emit_signal("button_pressed", "Vehicles/GrayCar")


func _on_Truck_pressed():
	emit_signal("button_pressed", "Vehicles/Truck")

