extends KinematicBody2D

var speed
var damage
var velocity = Vector2()
var rotation_angle
var parent_name

func init(sp, dmg, vel, rot, par_name):
	speed = sp
	damage = dmg
	velocity = vel
	$Sprite.rotate(rot)
	parent_name = par_name
	
func _process(delta):
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		if "Player" in collision.collider.get_name():
			collision.collider.got_shot(damage)


func Bullet_exited_screen():
	queue_free()
