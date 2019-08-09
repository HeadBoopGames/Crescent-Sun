extends Sprite

var attack_timer
export var attack_delay = 0.1
export var pickedup = false

onready var character = get_node("/root/Main/Player")
var can_shoot = true

var item_name = "Rifle"
var tag = "Item"

func _ready():
	attack_timer = Timer.new()
	attack_timer.set_one_shot(true)
	attack_timer.wait_time = attack_delay
	attack_timer.connect("timeout", self, "on_attacktimeout_complete")
	add_child(attack_timer)


func Shoot():
	if can_shoot:
		print("Pew pew!")
		var shot = load("res://Scenes/Bullet_Rifle.tscn").instance()
		shot.position = $BulletSpawnPoint.get_global_transform().get_origin()
		shot.rot = character.RotationPoint.rotation
		get_node("/root/").add_child(shot)
		can_shoot = false
		attack_timer.start()


func on_attacktimeout_complete():
	can_shoot = true

