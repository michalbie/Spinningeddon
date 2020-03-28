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
	self.rotate(rot)
	bullet_range = ran
	
func handle_collision(collision, collider):
	if collider.has_method("got_shot"):
		collider.got_shot(damage)
		GameManager.world.rpc("delete_bullet", self.get_name())
		
	elif "object_material" in collider:
		var collider_material = collider.object_material
		
		if collider_material == collider.materials.STONE:
			GameManager.world.rpc("delete_bullet", self.get_name())
			
		elif collider_material == collider.materials.METAL:
			var motion = collision.remainder.bounce(collision.normal)
			self.rotate(velocity.angle_to(motion))
			velocity = velocity.bounce(collision.normal)
			GameManager.bullets_info[self.get_name()]['rotation'] = self.rotation
			
	elif "bullet_range" in collider:
		GameManager.world.rpc("delete_bullet", self.get_name())
		GameManager.world.rpc("delete_bullet", collider.get_name())
	
