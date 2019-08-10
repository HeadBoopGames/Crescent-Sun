extends Area2D

export var speed = 0.1
var velocity = Vector2()
var rot
var HasHit

func _ready():
	velocity = (get_global_mouse_position() - get_node("/root/Main/Player").position).normalized()
	rotation = rot
	HasHit = false
	$BulletSound.play(0.0)

#func _process(delta):
#	if $ProcessRayCast2D.is_colliding():
#		set_process(false)
#	position += (velocity * speed)

func _physics_process(delta):
	position += (velocity * speed)

func _on_Lifetime_timeout():
	queue_free()


#func _on_Bullet_Rifle_area_entered(area):
#	print("Area Boop!")
#	set_physics_process(false)


func _on_Bullet_Rifle_body_entered(body):
	set_physics_process(false)
