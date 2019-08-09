extends RigidBody2D

var size
var area_position
var area_size

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s


# Make the Area2D where enemies spawns
func set_area_collision():
	area_position = position
	area_size = size
	var a = RectangleShape2D.new()
	a.extents = area_size
	$Area2D/CollisionShape2D.shape = a
	$CollisionShape2D.disabled = true