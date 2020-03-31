extends Node2D

var Bullet = preload("res://Entities/Bullet/Bullet.tscn")
var SoldierBullet = preload("res://Entities/Bullet/SoldierBullet.tscn")
var BattleRoyaleMap = preload("res://Maps/BattleRoyaleMap/BattleRoyaleMap.tscn")

var map

func _ready():
	map = BattleRoyaleMap.instance()
	add_child(map)

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
	get_node(bullet_name).queue_free()
	remove_child(get_node(bullet_name))
		
remotesync func kill_player(player_name, killer_name):
	GameManager.delete_player(player_name)
	if player_name == get_tree().get_network_unique_id() or get_tree().get_network_unique_id() in get_node(str(player_name)).observers_list:
		get_random_camera()
	get_node(str(player_name)).queue_free()
	
func get_random_camera():
	randomize()
	if GameManager.players_info.size() > 0:
		var random_index = randi() % GameManager.players_info.size()
		self.get_node(str(GameManager.players_info.keys()[random_index])).get_node("Camera2D").make_current()
		self.get_node(str(GameManager.players_info.keys()[random_index])).observers_list.append(get_tree().get_network_unique_id())

