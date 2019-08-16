extends Sprite

# The weapon decides what type of bullet it shoots
# Boolean Arguments:
# Piercing
# Exploding

var attack_timer
export var attack_delay = 0.0
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
		var shot = load("res://Scenes/Weapons/Bullet.tscn").instance()
		shot.position = $BulletSpawnPoint.get_global_transform().get_origin()
		shot.rot = character.RotationPoint.rotation
		get_node("/root/Main/BulletsContainer").add_child(shot)
		can_shoot = false
		attack_timer.start()
		character.get_node("Camera2D").camerashake()

func on_attacktimeout_complete():
	can_shoot = true