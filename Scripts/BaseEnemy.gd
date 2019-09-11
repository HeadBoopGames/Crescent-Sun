extends KinematicBody2D

onready var nav_2d : Navigation2D = get_node("/root/Main/Nav2D")
onready var target = get_node("/root/Main/Player")

var speed = 150.0
var path = PoolVector2Array() setget set_path

var player_in_chase_range
var player_in_attack_range
var can_attack

var attack_timer
var attack_delay = 0.5

var tag = "Enemy"

var health

func _ready():
	attack_timer = Timer.new()
#	attack_timer.set_one_shot(true)
	attack_timer.wait_time = attack_delay
	attack_timer.connect("timeout", self, "on_attacktimeout_complete")
	add_child(attack_timer)
	can_attack = true
	
	health = 5
	
	set_process(true)


func _process(delta: float):
	
	if player_in_chase_range:
		var new_path = nav_2d.get_simple_path(self.global_position, target.global_position)
		path = new_path
		
		var move_distance = speed * delta
		move_along_path(move_distance)
		
	
	if can_attack and player_in_attack_range:
		print("I'm attacking the player!")
		can_attack = false
		target.take_damage(5)
		attack_timer.start()


func move_along_path(distance : float):
	var start_point : = position
	for i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
			
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
			
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)


func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return
	set_process(true)


func _on_DetectionRadius_body_entered(body):
	if body.name == "Player":
		print("Player entered the detection range!")
		player_in_chase_range = true
		player_in_attack_range = false
#
#		var new_path = nav_2d.get_simple_path(self.global_position, body.global_position)
#		path = new_path
#		if path.size() == 2:
#			set_process(true)


func _on_DetectionRadius_body_exited(body):
	if body.name == "Player":
		print("Player left the detection range!")
		player_in_chase_range = false
		player_in_attack_range = false
#		var new_path = nav_2d.get_simple_path(self.global_position, body.global_position)
#		path = nav_2d.get_simple_path(self.global_position, body.global_position)
#		set_process(true)


func _on_AttackRadius_body_entered(body):
	if body.name == "Player":
		player_in_chase_range = false
		player_in_attack_range = true
		can_attack = true
		attack_timer.start()


func _on_AttackRadius_body_exited(body):
	if body.name == "Player":
		player_in_chase_range = true
		player_in_attack_range = false
		can_attack = false
		attack_timer.stop()


func on_attacktimeout_complete():
	can_attack = true
	
func take_damage(damage):
	health -= damage
	if health <= 0:
		print("You got meeeeeehhhhh!")
		queue_free()
	
