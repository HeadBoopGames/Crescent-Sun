extends Node

func goto_scene(scene):
	match scene:
		"MainMenu":
			print("BOOP!")
			
		"Main":
			get_tree().change_scene("res://Scenes/Main.tscn")
			
		"RoomScene":
			get_tree().change_scene("res://Scenes/RoomScene.tscn")
		