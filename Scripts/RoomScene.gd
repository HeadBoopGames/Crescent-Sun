extends Node2D

var rooms = [[0, 0, 0, 0,], [0, 0, 0, 0,], [0, 0, 0, 0,], [0, 0, 0, 0]]
var Room = preload("res://Scenes/BaseRoom.tscn")
var rifle = preload("res://Scenes/Weapons/Rifle.tscn")
var Player = preload("res://Scenes/Player.tscn")

var play_mode = false
var player = null

func _init():
	randomize()
	var x = 1
	var y = 1
	for i in range(16):
		rooms[x][y] = 1
		var dir = (randi() % 4)*90
		x += lengthdir_x(1, dir)
		y += lengthdir_y(1, dir)
		x = clamp(x, 0, 3)
		y = clamp(y, 0, 3)
		
func lengthdir_x(length, direction):
	return length*cos(direction)

func lengthdir_y(length, direction):
	return length*sin(direction)
	
func _ready():
	var roomID = 0
	for y in range(4):
		var row = rooms[y]
		for x in range(4):
			if row[x]:
				var room = Room.instance()
				var room_pos = Vector2(1280*x, 736*y) + Vector2(-1280, -736)
				room.position = room_pos
				room.roomID = roomID
				roomID += 1
				$Rooms.add_child(room)

	for r in $Rooms.get_children():
		r.lookForRooms()
	
		if r.roomID == 0:
			# This is the first room!
			player = Player.instance()
	#		get_node("Camera2D").current = false
			add_child(player)
			player.position = Vector2(r.position.x + 640, r.position.y + 368)
			print("This is the first room!")

		if r.roomID != 0 and r.roomID != $Rooms.get_child_count() - 1:
			var Rifle = rifle.instance()
			Rifle.position = Vector2(r.position.x + 640, r.position.y + 368)
			get_node("Weapons").add_child(Rifle)
	
		if r.roomID == $Rooms.get_child_count() - 1:
			# Spawn a way deeper into the dungeons
			print("This is the last room!")
		
	