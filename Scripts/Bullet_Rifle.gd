extends RigidBody2D

export var speed = 1
var target
var velocity = Vector2()
var rot

func _ready():
	target = get_global_mouse_position()
	velocity = -(position - target).normalized()
	rotation = rot


func _process(delta):
	position += (velocity * speed)


func _on_Lifetime_timeout():
	print("Old bullet vanished!")
	queue_free()

func _on_Bullet_body_entered(body):
	print("Boop!")
