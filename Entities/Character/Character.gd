extends KinematicBody2D

export (int) var move_speed
export (String) var character_class
export (float) var rotate_cooldown
export (int) var rotate_speed

var rotate_direction = 1  #1 = right, -1 = left
var can_rotate = true
var inside_standing_circle = false
onready var id = int(self.get_name())

remote var mouse_pos = Vector2()
remote var shoot_pressed = false
remote var switch_pressed = false

func _process(delta):
	handle_inputs()
	move(delta)
	rotate_player(delta)
	get_parent().players[id] = {"position": position, "rotation": $Body.rotation, "updated": true}
	send_dictionary()
	
func handle_inputs():
	if switch_pressed:
		rotate_direction = -rotate_direction
		switch_pressed = false
		can_rotate = false
		$RotateCooldown.start(rotate_cooldown)
<<<<<<< Updated upstream
	
=======
		
	if shoot_pressed:
		shoot_pressed = false
		shoot()

>>>>>>> Stashed changes
func move(delta):
	if !inside_standing_circle:
		var direction = mouse_pos - position
		var velocity_vector = direction.normalized() * move_speed * delta
		move_and_collide(velocity_vector)
		get_parent().players[id][position] = position
		rset_id(id, "player_position", self.position)

func rotate_player(delta):
	$Body.rotate(rotate_direction * rotate_speed * delta)
	get_parent().players[id][rotation] = $Body.rotation
	rset_id(id, "player_rotation", $Body.rotation)

func RotateCooldown_timeout():
	can_rotate = true
	$RotateCooldown.stop()

func StandingCircle_mouse_entered():
	inside_standing_circle = true

func StandingCircle_mouse_exited():
	inside_standing_circle = false
