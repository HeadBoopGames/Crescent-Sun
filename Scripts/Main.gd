extends Node2D

var title = "Crescent Sun"
var version = "V 0.0.1"

var Room = preload("res://Scenes/Room.tscn")
var Player = preload("res://Scenes/Player.tscn")
var placeholder = preload("res://Scenes/Placeholder.tscn")
var rifle = preload("res://Scenes/Weapons/Rifle.tscn")

onready var Map = $TileMap

var tile_size = 32
var num_rooms = 20
var min_size = 4
var max_size = 8
var hspread = 500
var cull = 0.15

var path # AStar pathfinding object
var start_room = null
var end_room = null
var play_mode = false
var player = null


func _ready():
	randomize()
	make_rooms()
	
	# Wait for rooms
	yield(get_tree().create_timer(2.1), 'timeout')
	
	make_map()
	
	# Wait for map
	yield(get_tree().create_timer(1), 'timeout')
	
	if not play_mode:
		player = Player.instance()
		get_node("Camera2D").current = false
		add_child(player)
		player.position = start_room.position
		play_mode = true
		

	# Wait for map
	yield(get_tree().create_timer(0.3), 'timeout')
	
	populate_map()


func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread),0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
		yield(get_tree().create_timer(0.01), 'timeout')
	
	# Wait for movement to stop
	yield(get_tree().create_timer(1.1), 'timeout')
	
	# cull rooms
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x, room.position.y, 0))
			room.set_area_collision()
	
	yield(get_tree(), 'idle_frame')
	
	# Generate a minimum spanning tree connecting the rooms
	path = find_mst(room_positions)


func _draw():
	if play_mode:
		return
		
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(23, 288, 0), false)
	
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 1, 0), 15, true)


func _process(delta):
#	if not play_mode:
	update()
	OS.set_window_title(title + " " + version + " | FPS: " + str(Engine.get_frames_per_second()))


func _input(event):
	if event.is_action_pressed('ui_accept'):
		if play_mode:
			player.queue_free()
			play_mode = false
		for n in $Rooms.get_children():
			n.queue_free()
		path = null
		start_room = null
		end_room = null
		make_rooms()
	
	if event.is_action_pressed("ui_focus_next"):
		make_map()
		
	if event.is_action_pressed("ui_cancel"):
		if not play_mode:
			player = Player.instance()
			get_node("Camera2D").current = false
			add_child(player)
			player.position = start_room.position
			play_mode = true


func find_mst(nodes):
	# Prim's algorithm
	# Give an array of possitions (nodes), generates a minimum
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	# repeat until no more nodes remain
	while nodes:
		var min_dist = INF # Minimum distance so far
		var min_p = null # Position of that node
		var p = null # Current position
		
		# Loop through points in path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			
			# Loop through the remaining nodes
			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
					
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
	return path


func make_map():
	# Create a TileMap from the generated rooms and path
	Map.clear()
	find_start_room()
	find_end_room()
	
	# Fill TileMap with walls, then carve empty rooms
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position - room.size, room.get_node("CollisionShape2D").shape.extents * 2)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)
	for x in range(topleft.x - 8, bottomright.x + 8):
		for y in range(topleft.y - 8, bottomright.y + 8):
			Map.set_cell(x, y, 0) # Set all cells to Wall
	
	# Carve rooms
	var corridors = [] # One corridor per connection
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = Map.world_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(0, s.x * 2): #range(0, s.x * 2): # Add this if you want to have separate rooms: range(2, s.x * 2 - 1):
			for y in range(0, s.y * 2): # Add this if you want to have separate rooms: range(2, s.y * 2 - 1):
				var floor_tile = 0
				var tile_ID = range(1,101)[randi()%range(1,101).size()]
				if tile_ID <= 21:
					floor_tile = range(2,14)[randi()%range(2,14).size()]
				else:
					floor_tile = 1
				Map.set_cell(ul.x + x, ul.y + y, floor_tile) # Set rooms to Floor
		
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)


func carve_path(pos1, pos2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	
	# Choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, 1)
		Map.set_cell(x, x_y.y + y_diff, 1)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, 1)
		Map.set_cell(y_x.x + x_diff, y, 1)


func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x


func find_end_room():
	var max_x = INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x


func populate_map():
	for room in $Rooms.get_children():
		if room != start_room:
			var Rifle = rifle.instance()
			Rifle.position = Vector2(room.position.x, room.position.y)
			get_node("EnemyContainer").add_child(Rifle)