extends Node

var ammo_bullets
var ammo_shells
var ammo_energy
var ammo_explosion

func _ready():
	ammo_bullets = 20
	ammo_energy = 20
	ammo_explosion = 20
	ammo_shells = 20

func goto_scene(scene):
	match scene:
		"MainMenu":
			print("BOOP!")
			
		"Main":
			get_tree().change_scene("res://Scenes/Main.tscn")
#			var UI = load("res://UI.tscn").instance()
#			get_node("/root/").add_child(UI)
			
		"RoomScene":
			get_tree().change_scene("res://Scenes/RoomScene.tscn")
		