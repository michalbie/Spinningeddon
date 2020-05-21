extends Camera2D

func camera_shoot_recoil():
	#var random_offsets = Vector2(float(randi() % 20-10), float(randi() % 20-10))
	#$Tween.interpolate_property(self, "offset",
	#random_offsets, Vector2(0, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#$Tween.start()
	var random_offsets = Vector2(0, -20).rotated(get_parent().rotation + deg2rad(180.0))
	$Tween.interpolate_property(self, "offset",
	random_offsets, Vector2(0, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	#commented part is camera shaking, second uncommented part is camera backing (i dont know what is better)
