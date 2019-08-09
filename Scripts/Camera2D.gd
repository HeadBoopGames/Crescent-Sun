extends Camera2D

func _ready():
	set_process(true)

func _process(delta):
	position = ((Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2) + get_viewport().get_mouse_position()) / 2) - (Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2))
	# position = (get_viewport().get_mouse_position() + get_parent().position) / 2
	# position = (get_parent().position + get_viewport().get_mouse_position()) # / 2
	# position = ((get_viewport().size / 2) + get_viewport().get_mouse_position()) / 2