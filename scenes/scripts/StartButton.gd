extends Button

func _on_pressed():
	call_deferred("start_1_scene")

func start_1_scene():
	#get_tree().change_scene_to_file(str("res://scenes/levels/Level2Transition.tscn"))
	#get_tree().change_scene_to_file(str("res://scenes/levels/Level2.tscn"))
	get_tree().change_scene_to_file(str("res://scenes/cutscenes/Start1.tscn"))
	#get_tree().change_scene_to_file(str("res://scenes/cutscenes/InTheRuin.tscn"))
	#get_tree().change_scene_to_file(str("res://scenes/cutscenes/Epilogue.tscn"))
	#get_tree().change_scene_to_file(str("res://scenes/levels/Level1.tscn"))

func _on_exit_pressed():
	call_deferred("exit_game")
	
func exit_game():
	get_tree().quit()
