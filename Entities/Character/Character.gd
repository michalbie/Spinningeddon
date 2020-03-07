extends KinematicBody2D

var Bullet = preload("res://Entities/Bullet/Bullet.tscn")

export (int) var move_speed
export (String) var character_class
export (float) var rotate_cooldown
export (int) var rotate_speed
export (float) var hp
export (int) var bullet_speed
export (int) var bullet_damage

var rotate_direction = -1  #1 = right, -1 = left
var can_rotate = true
var inside_standing_circle = false


func _process(delta):
	listen_inputs()
	move(delta)
	rotate_player(delta)
	
func listen_inputs():
	if Input.is_action_just_pressed("switch_rotation") and can_rotate:
		rotate_direction = -rotate_direction
		can_rotate = false
		$RotateCooldown.start(rotate_cooldown)
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func move(delta):
	if !inside_standing_circle:
		var direction = get_viewport().get_mouse_position() - position
		var velocity_vector = direction.normalized() * move_speed * delta
		move_and_collide(velocity_vector)

func rotate_player(delta):
	$Body.rotate(rotate_direction * rotate_speed * delta)

func shoot():
	var bullet = Bullet.instance()
	bullet.global_position = get_node("Body/Rifle/Bullet_spawn").global_position
	bullet.init(bullet_speed, bullet_damage, Vector2(0, -1).rotated($Body.rotation),
				$Body.rotation, self.get_name())
	get_parent().add_child(bullet)

func got_shot(dmg):
	if dmg >= hp:
		hp = 0
		queue_free()
	else:
		hp -= dmg


func RotateCooldown_timeout():
	can_rotate = true
	$RotateCooldown.stop()

func StandingCircle_mouse_entered():
	inside_standing_circle = true

func StandingCircle_mouse_exited():
	inside_standing_circle = false
