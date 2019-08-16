extends Area2D

export (bool) var CollisionEnabled
export (float) var speed = 0.1
var velocity = Vector2()
var rot
var HasHit
export (bool) var muted
export (bool) var piercing
export (bool) var exploding

func _ready():
	velocity = (get_global_mouse_position() - get_node("/root/Main/Player").position).normalized()
	rotation = rot
	HasHit = false
	if not muted:
		$BulletSound.play(0.0)

func _physics_process(delta):
	position += (velocity * speed)

func _on_Lifetime_timeout():
	queue_free()

func _on_Bullet_Rifle_body_entered(body):
#	get_node("/root/Main/Player/Camera2D").camerashake()
	
	if exploding:
		if body.name == "TileMap":
			var col_pos_01 = $TileDetectionPoint_01.get_global_transform().get_origin()
			var col_pos_02 = $TileDetectionPoint_02.get_global_transform().get_origin()
			var cell_pos_01 = body.world_to_map(col_pos_01)
			var cell_pos_02 = body.world_to_map(col_pos_02)
			if cell_pos_01 != cell_pos_02:
				body.set_cell(cell_pos_01.x, cell_pos_01.y, 1)
				body.set_cell(cell_pos_02.x, cell_pos_02.y, 1)
			else:
				body.set_cell(cell_pos_01.x, cell_pos_01.y, 1)
		
	if not piercing:
		queue_free()
