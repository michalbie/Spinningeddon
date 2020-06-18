extends Node2D

var Bullet = preload("res://Entities/Bullet/Bullet.tscn")
var SoldierBullet = preload("res://Entities/Bullet/SoldierBullet.tscn")
var Healthpack = preload("res://Entities/Healthpack/Healthpack.tscn")
var BattleRoyaleMap = preload("res://Maps/BattleRoyaleMap/BattleRoyaleMap.tscn")

var GameplayInfo = preload("res://Scenes/HUD/GameplayInfo.tscn")
var SpectatorSystem = preload("res://Scenes/HUD/SpectatorSystem.tscn")

var PlayerCorpse = preload("res://Entities/Character/Corpse.tscn")

var map
var gameplay_info
var spectator_system


func _ready():
	map = BattleRoyaleMap.instance()
	add_child(map)
	gameplay_info = GameplayInfo.instance()
	add_child(gameplay_info)
	
	if get_tree().is_network_server():
		spectator_system = SpectatorSystem.instance()
		spectator_system.set_name("SpectatorSystem")
		add_child(spectator_system)


remotesync func spawn_bullet(player_id, is_soldier_bullet=false):
	var bullet
	if is_soldier_bullet:
		bullet = SoldierBullet.instance()
	else:
		bullet = Bullet.instance()
	var player = get_node(str(player_id))
	bullet.set_name("bullet" + str(GameManager.bullets_count))
	add_child(bullet)
	bullet.global_position = player.get_node("Body/Bullet_spawn").global_position
	bullet.init(player.bullet_speed, player.bullet_damage, 
				Vector2(0, -1).rotated(player.rotation), 
				player.rotation, player.bullet_range, str(player_id))
	GameManager.bullets_info[bullet.get_name()] = {"position": bullet.global_position, "rotation": bullet.rotation}
	GameManager.bullets_count += 1

remotesync func delete_bullet(bullet_name):
	GameManager.bullets_info.erase(bullet_name)
	if get_node(bullet_name) != null:
		get_node(bullet_name).queue_free()
		remove_child(get_node(bullet_name))
		
remotesync func delete_healthpack(healthpack_name):
	if get_node(healthpack_name) != null:
		get_node(healthpack_name).queue_free()
		remove_child(get_node(healthpack_name))

remotesync func kill_player(player_name, killer_name):
	GameManager.delete_player(player_name)

	if player_name == get_tree().get_network_unique_id():
		spectator_system = SpectatorSystem.instance()
		add_child(spectator_system)
		spectator_system.set_name("SpectatorSystem")
		spectator_system.get_random_camera()
		spectator_system.get_node_or_null("HUD").update_players_alive()
		
	if get_tree().get_network_unique_id() in get_node(str(player_name)).observers_list:
		spectator_system.get_random_camera()
		spectator_system.get_node_or_null("HUD").update_players_alive()

	if get_node(str(player_name)) != null:
		var corpse = PlayerCorpse.instance()
		corpse.set_position(get_node(str(player_name)).position - corpse.get_rect().size / 2)
		add_child(corpse)
		SoundManager.rpc("play_death_sound", corpse.get_rect().position, corpse.get_name())
		var healthpack = Healthpack.instance()
		healthpack.set_position(get_node(str(player_name)).position)
		add_child(healthpack)
		get_node(str(player_name)).queue_free()
		get_node("label_" + str(player_name)).queue_free()
		

