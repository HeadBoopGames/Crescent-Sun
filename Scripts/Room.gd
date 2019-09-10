extends RigidBody2D

var size
var area_position
var area_size
var tag = "FillRoom"

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = size * 1.3
	$CollisionShape2D.shape = s


# Make the Area2D where enemies spawns
func set_area_collision():
#	area_position = Vector2(position.x, position.y)
#	$Area2D/CollisionShape2D.position = area_position
	area_size = size * 0.85
	var a = RectangleShape2D.new()
	a.extents = area_size
	$Area2D/CollisionShape2D.shape = a
#	$Area2D/CollisionShape2D.disabled = true
#	$CollisionShape2D.disabled = true

func disable_collisions():
	$Area2D/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = true


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		pass
		
#		body.get_node("Camera2D").current = false
#		body.get_node("Camera2D").overlapping_room = true
#		body.get_node("Camera2D").position = self.position
#		get_node("/root/Main/Camera2D").overlapping_room = true
#		get_node("/root/Main/Camera2D").position = self.position
#		body.in_room = true
#		get_node("/root/Main/Camera2D").current = true
#		print(size)



func _on_Area2D_body_exited(body):
	if body.name == "Player":
		pass
		
#		body.in_room = false
#		body.get_node("Camera2D").overlapping_room = false
#		get_node("/root/Main/Camera2D").overlapping_room = false
#		body.get_node("Camera2D").current = true
#		get_node("/root/Main/Camera2D").current = false
