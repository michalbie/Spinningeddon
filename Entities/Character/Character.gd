extends KinematicBody2D

var Bullet = preload("res://Entities/Bullet/Bullet.tscn")
var HUD = preload("res://Scenes/HUD/HUD.tscn")

signal input_ready(input)
signal player_died

var Globals = preload("res://Scripts/Globals.gd")
export(preload("res://Scripts/Globals.gd").level) var move_speed
export(preload("res://Scripts/Globals.gd").level) var rotate_cooldown
export(preload("res://Scripts/Globals.gd").level) var rotate_speed
export(preload("res://Scripts/Globals.gd").level) var shoot_cooldown
export(preload("res://Scripts/Globals.gd").level) var bullet_speed
export(preload("res://Scripts/Globals.gd").level) var bullet_damage
export(preload("res://Scripts/Globals.gd").level) var bullet_range
export(preload("res://Scripts/Globals.gd").level) var hp
export (String) var description

var inside_circle = false
var switch_rotation = false
var rotate_direction = 1 #-1 - left, 1 - right
var shoot = false
var being_removed = false
var max_hp
var kills = 0

var observers_list = []
var hud
var is_server = false

func _ready():
	is_server = get_tree().is_network_server()
	connect("input_ready", Server, "_on_input_ready")
	move_speed = Globals.move_speed[move_speed]
	rotate_cooldown = Globals.rotate_cooldown[rotate_cooldown]
	rotate_speed = Globals.rotate_speed[rotate_speed]
	shoot_cooldown = Globals.shoot_cooldown[shoot_cooldown]
	bullet_speed = Globals.bullet_speed[bullet_speed]
	bullet_damage = Globals.bullet_damage[bullet_damage]
	bullet_range = Globals.bullet_range[bullet_range]
	hp = Globals.hp[hp]
	max_hp = hp
	
	if is_server == false and self.get_name() == str(get_tree().get_network_unique_id()):
		hud = HUD.instance()
		add_child(hud)
		GameManager.connect("game_started", hud, "initialize")
	elif is_server == true:
		hud = HUD.instance()
		add_child(hud)
		
	if self.get_name() == str(get_tree().get_network_unique_id()):
		self.get_node("Camera2D").current = true

func _physics_process(delta):
	if !is_server and str(get_tree().get_network_unique_id()) == self.get_name():
		if !being_removed:
			listen_inputs()
			send_inputs(delta)

func listen_inputs():
	if Input.is_action_just_pressed("switch_rotation"):
		switch_rotation = true
		
	if Input.is_action_pressed("shoot"):
		#$Camera2D.camera_shoot_recoil()
		shoot = true
		
	if Input.is_action_just_released("shoot"):
		shoot = false

func send_inputs(delta):
	var mouse_pos = get_global_mouse_position()
	var player_input = {}
	player_input['delta'] = delta
	player_input['mouse_pos'] = mouse_pos
	player_input['inside_circle'] = inside_circle
	player_input['switch_rotation'] = switch_rotation
	player_input['shoot'] = shoot
	switch_rotation = false
	shoot = false
	
	if !being_removed:
		emit_signal("input_ready", player_input)

func got_shot(dmg, source):
	if dmg >= hp:
		hp = 0
		being_removed = true
		GameManager.world.gameplay_info.rpc("update_kills_info", str(source), self.get_name())
		
		if source != "Fog":
			GameManager.world.get_node(str(source)).hud.rpc("update_players_alive")
			GameManager.world.get_node(str(source)).kills += 1
			GameManager.world.get_node(str(source)).hud.rpc_id(int(source), "update_kills", GameManager.world.get_node(str(source)).kills)
			for id in GameManager.world.get_node(str(source)).observers_list:
				GameManager.world.spectator_system.get_node("HUD").rpc_id(int(id), "update_kills", GameManager.world.get_node(str(source)).kills)
		else:
			GameManager.world.get_node(self.get_name()).hud.rpc("update_players_alive")
			SoundManager.rpc_id(int(self.get_name()), "stop_fog_sound")
			
		emit_signal("player_died")
		GameManager.world.rpc("kill_player", int(self.get_name()), source)
	else:
		hp -= dmg
		if hud != null:
			hud.rpc_id(int(self.get_name()), "update_hp", hp)
			for id in observers_list:
				GameManager.world.spectator_system.get_node("HUD").rpc_id(int(id), "update_hp", hp)
				
remotesync func append_observer(observer_id):
	observers_list.append(observer_id)
	
remotesync func erase_observer(observer_id):
	observers_list.erase(observer_id)
	

func _on_StandingCircle_mouse_entered():
	inside_circle = true

func _on_StandingCircle_mouse_exited():
	inside_circle = false

func _on_RotateCooldown_timeout():
	$RotateCooldown.stop()


func _on_ShootCooldown_timeout():
	$ShootCooldown.stop()

