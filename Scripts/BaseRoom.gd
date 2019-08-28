extends Node2D

var roomID = 0
var tag

func lookForRooms():
	$Area2D/RC_North.force_raycast_update()
	$Area2D/RC_South.force_raycast_update()
	$Area2D/RC_East.force_raycast_update()
	$Area2D/RC_West.force_raycast_update()
	
	
	if $Area2D/RC_North.is_colliding():
		print($Area2D/RC_North.get_collider())
		$TileMap.set_cell(18,0,1)
		$TileMap.set_cell(19,0,1)
		$TileMap.set_cell(20,0,1)
		$TileMap.set_cell(21,0,1)
		$TileMap.set_cell(22,0,25)
		$TileMap.set_cell(17,0,26)
		
		$TileMap.set_cell(18,1,1)
		$TileMap.set_cell(19,1,1)
		$TileMap.set_cell(20,1,1)
		$TileMap.set_cell(21,1,1)
		$TileMap.set_cell(22,1,4)
		$TileMap.set_cell(17,1,5)
		
	if $Area2D/RC_South.is_colliding():
		$TileMap.set_cell(18,21,1)
		$TileMap.set_cell(19,21,1)
		$TileMap.set_cell(20,21,1)
		$TileMap.set_cell(21,21,1)
		$TileMap.set_cell(17,21,40)
		$TileMap.set_cell(22,22,23)
		
		$TileMap.set_cell(18,22,1)
		$TileMap.set_cell(19,22,1)
		$TileMap.set_cell(20,22,1)
		$TileMap.set_cell(21,22,1)
		$TileMap.set_cell(22,21,39)
		$TileMap.set_cell(17,22,24)
		
	if $Area2D/RC_East.is_colliding():
		$TileMap.set_cell(39,10,1)
		$TileMap.set_cell(39,11,1)
		$TileMap.set_cell(39,12,1)
		$TileMap.set_cell(39,13,17)
		
		$TileMap.set_cell(39,9,21)
		$TileMap.set_cell(39,8,16)
		
		$TileMap.set_cell(38,10,1)
		$TileMap.set_cell(38,11,1)
		$TileMap.set_cell(38,12,1)
		$TileMap.set_cell(38,13,39)
		
		$TileMap.set_cell(38,9,4)
		$TileMap.set_cell(38,8,25)
		
	if $Area2D/RC_West.is_colliding():
		$TileMap.set_cell(0,10,1)
		$TileMap.set_cell(0,11,1)
		$TileMap.set_cell(0,12,1)
		$TileMap.set_cell(0,13,17)
		
		$TileMap.set_cell(0,9,18)
		$TileMap.set_cell(0,8,16)
		
		$TileMap.set_cell(1,10,1)
		$TileMap.set_cell(1,11,1)
		$TileMap.set_cell(1,12,1)
		$TileMap.set_cell(1,13,40)
		
		$TileMap.set_cell(1,9,5)
		$TileMap.set_cell(1,8,26)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		get_node("/root/RoomScene/Camera2D").position.x = $Area2D/CenterPoint.get_global_transform().get_origin().x
		get_node("/root/RoomScene/Camera2D").position.y = $Area2D/CenterPoint.get_global_transform().get_origin().y
		
		populate_room()
		
func populate_room():
	# As the player enters the room, enemies will pop in from the ground, beaming in or from behind props.
	pass