extends KinematicBody2D

signal input_ready(input)

export (int) var move_speed

var players_info = {}

func _ready():
	connect("input_ready", GameManager, "_on_input_ready")

func _process(delta):
	if !get_tree().is_network_server():
		handle_inputs(delta)
	update_world()

func handle_inputs(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var player_input = {"mouse_pos": mouse_pos, "delta": delta}
	emit_signal("input_ready", player_input)
	
func _on_player_update_ready(id, player_info):
	print(get_tree().get_root().get_node("World").get_children()[0].get_name())
	rpc_unreliable("update_players_info", id, player_info)
	
remotesync func update_players_info(id, player_info):
	#print("Update info method " + str(player_info))
	players_info[id] = player_info
	
func update_world():
	#print(players_info)
	for player_id in players_info:
		get_parent().get_node(str(player_id)).global_position = players_info[player_id]["position"]
	
