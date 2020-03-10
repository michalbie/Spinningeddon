extends KinematicBody2D

export (int) var move_speed

var players_info = {}

func _process(delta):
	handle_inputs(delta)
	update_world()

func handle_inputs(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var player_input = {"mouse_pos": mouse_pos, "delta": delta}
	rpc_unreliable_id(1, "process_input", player_input)
	
remotesync func update_players_info(id, player_info):
	players_info[id] = player_info
	
func update_world():
	for player_id in players_info:
		get_parent().get_node(str(player_id)).global_position = players_info[player_id]["position"]
	
