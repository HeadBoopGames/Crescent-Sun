extends Area2D

var tag = "EXIT"

func _on_Exit_body_entered(body):
	if body.name == "Player":
		body.interact_with = self


func _on_Exit_body_exited(body):
	if body.name == "Player":
		body.interact_with = null

func exit():
	GameInstance.goto_scene("Main")