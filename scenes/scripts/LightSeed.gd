extends Area2D

func _on_body_entered(body):
	if body.name == "Knight":
		print("masuk")
		Global.add_light_seed()
		queue_free()
