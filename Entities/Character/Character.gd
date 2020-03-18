extends KinematicBody2D

var Bullet = preload("res://Entities/Bullet/Bullet.tscn")

signal input_ready(input)

export (int) var move_speed
export (float) var rotate_cooldown
export (int) var rotate_speed
export (int) var bullet_speed
export (int) var bullet_damage
export (int) var bullet_range
export (int) var hp

var inside_circle = false
var switch_rotation = false
var rotate_direction = 1 #-1 - left, 1 - right
var shoot = false

var being_removed = false

func _ready():
	connect("input_ready", Server, "_on_input_ready")

func _physics_process(delta):
	if !get_tree().is_network_server() and str(get_tree().get_network_unique_id()) == self.get_name():
		if !being_removed:
			listen_inputs()
			send_inputs(delta)

func listen_inputs():
	if Input.is_action_just_pressed("switch_rotation"):
		switch_rotation = true
		
	if Input.is_action_just_pressed("shoot"):
		shoot = true

func send_inputs(delta):
	var mouse_pos = get_viewport().get_mouse_position()
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

func got_shot(dmg):
	if dmg >= hp:
		hp = 0
		being_removed = true
		GameManager.world.rpc("kill_player", int(self.get_name()))
	else:
		hp -= dmg

func _on_StandingCircle_mouse_entered():
	inside_circle = true

func _on_StandingCircle_mouse_exited():
	inside_circle = false

func _on_RotateCooldown_timeout():
	$RotateCooldown.stop()
