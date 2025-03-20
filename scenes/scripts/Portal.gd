extends Area2D

@export var target_scene: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Masuk portal!")
		call_deferred("change_scene")

func change_scene():
	get_tree().change_scene_to_file("res://scenes/" + target_scene + ".tscn")
