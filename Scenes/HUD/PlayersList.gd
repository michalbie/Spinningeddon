extends CanvasLayer

var ListCell = preload("res://Scenes/HUD/share/PlayersListElement.tscn")

func _ready():
	var row_count = 1
	var column_count = 1
	for player in LobbyManager.players:
		if column_count == 5:
			row_count += 1
			column_count = 1
		else:
			var cell = ListCell.instance()
			cell.set_text(LobbyManager.players[int(player)]['name'])
			if (row_count % 2 == 0 and column_count % 2 != 0) or (row_count % 2 != 0 and column_count % 2 == 0):
				cell.add_color_override("font_color", Color(0.21, 0.21, 0.21, 1))
			get_node("Control/CenterContainer/ListBackground/MarginContainer/Row" + str(row_count)).add_child(cell)
			column_count += 1
