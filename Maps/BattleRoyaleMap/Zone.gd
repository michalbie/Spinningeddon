extends Node2D

export var time_to_shrink = 120
export var damage_dealt = 50
export var damage_interval = 2

func _ready():
	var fog_tween = get_node("FogTween")
	fog_tween.interpolate_property($SafeZone, "texture_scale",
	40, 3, time_to_shrink, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	fog_tween.start()
	
	var safe_area_tween = get_node("SafeAreaTween")
	safe_area_tween.interpolate_property($AreaZone/SafeArea.shape, "radius",
	9200, 690, time_to_shrink, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	safe_area_tween.start()
	
func _on_Game_Started():
	for player in LobbyManager.players:
		var timer = Timer.new()
		var player_node = GameManager.world.get_node(str(player))
		timer.connect("timeout", self, "_on_DamageTimer_timeout", [player_node])
		timer.set_wait_time(damage_interval)
		timer.set_name(str(player))
		add_child(timer)

func _on_Area2D_body_exited(body):
	if body.has_method("got_shot"):
		get_node(body.get_name()).start()

func _on_Area2D_body_entered(body):
	if body.has_method("got_shot"):
		var t = get_node_or_null(body.get_name())
		if t != null:
			t.stop()

func _on_DamageTimer_timeout(player):
	player.got_shot(damage_dealt, "Fog")

