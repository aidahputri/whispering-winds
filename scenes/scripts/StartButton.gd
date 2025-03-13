extends Button

@onready var border = $Border

func _on_mouse_entered():
	border.visible = true

func _on_mouse_exited():
	border.visible = false
	
func _on_pressed():
	call_deferred("start_1_scene")

func start_1_scene():
	get_tree().change_scene_to_file(str("res://scenes/levels/Level1.tscn"))
