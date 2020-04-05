extends CanvasLayer

signal screen_disappeared

func _ready():
	connect("screen_disappeared", GameManager, "end_game")

func set_winner(winner):
	get_node("MarginContainer/VBoxContainer/Winner").set_text(str(winner) + " won the Game!")

func _on_Timer_timeout():
	emit_signal("screen_disappeared")
	queue_free()
