extends Camera2D

export var shake_amount = 1.0
var shake = false
export var shake_time = 0.3
var shake_timer

func _ready():
	set_process(true)
	shake_timer = Timer.new()
	shake_timer.wait_time = shake_time
	shake_timer.connect("timeout", self, "on_shaketimer_timeout_complete")
	add_child(shake_timer)

func _process(delta):
	position = ((Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2) + get_viewport().get_mouse_position()) / 2) - (Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2))
	
	if shake:
		self.set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount))

func camerashake():
	shake = true
	shake_timer.start()
	
func on_shaketimer_timeout_complete():
	shake = false