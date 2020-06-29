extends MarginContainer

var ValuePoint = preload("res://Scenes/Lobby/share/ValuePoint.tscn")

func _ready():
	load_stats()
	
func load_stats():
	for stat in $"CenterContainer/MarginContainer/VBoxContainer/Stats".get_children():
		var class_scene = Globals.classes[self.get_name()]["scene"].instance()
		var stat_name = stat.get_name()
		
		if stat_name != "Description":
			for i in range(class_scene.get(stat_name) + 1):
				add_value_point(stat)
		else:
			stat.text = class_scene.description
		
		
func add_value_point(container):
	var point = ValuePoint.instance()
	container.add_child(point)


