extends KinematicBody2D

var speed
var damage
var velocity = Vector2()
var rotation_angle
var bullet_range

remote var distance_traveled = 0

func init(sp, dmg, vel, rot, ran):
	speed = sp
	damage = dmg
	velocity = vel
	$Sprite.rotate(rot)
	bullet_range = ran
