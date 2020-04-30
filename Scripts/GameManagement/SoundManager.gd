extends Node

var win_sound

func _ready():
	win_sound = AudioStreamPlayer.new()
	add_child(win_sound)
	win_sound.stream = load("res://Sounds/spinigeddonWinSound.wav")
	win_sound.volume_db = -20

remote func play_moving_sound(player_name):
	if GameManager.in_game == true:
		if !GameManager.world.get_node_or_null(player_name + "/Sounds/MovingSound").playing and get_tree().get_network_unique_id() != int(player_name):
			GameManager.world.get_node(player_name + "/Sounds/MovingSound").play()
		
remote func stop_moving_sound(player_name):
	GameManager.world.get_node(player_name + "/Sounds/MovingSound").stop()

remote func play_shoot_sound(player_name):
	GameManager.world.get_node(player_name + "/Sounds/ShootSound").play()

remote func play_hit_material_sound(object_name):
	GameManager.world.map.get_node(object_name + "/Sounds/HitMaterialSound").play()

remote func play_penetrate_sound(object_name):
	GameManager.world.map.get_node(object_name + "/Sounds/PenetrateSound").play()

remote func play_ricochet_sound(object_name):
	GameManager.world.map.get_node(object_name + "/Sounds/RicochetSound").play()

remote func play_victory_music():
	win_sound.play()
	
remote func play_fog_sound():
	GameManager.world.map.get_node("Zone/Sounds/FogSound").play()
	
remote func stop_fog_sound():
	GameManager.world.map.get_node("Zone/Sounds/FogSound").stop()
	
remote func play_death_sound(corpse_position, corpse_name):
	var death_position = Node2D.new()
	death_position.set_name(corpse_name)
	death_position.add_child(create_death_sound())
	death_position.position = corpse_position
	add_child(death_position)
	get_node(corpse_name).get_node_or_null("DeathSound").play()
	
func create_death_sound():
	var death_sound = AudioStreamPlayer2D.new()
	death_sound.set_name("DeathSound")
	death_sound.max_distance = 500
	death_sound.volume_db = 20
	death_sound.stream = load("res://Sounds/spiningeddonCharacterDeath.wav")
	return death_sound
