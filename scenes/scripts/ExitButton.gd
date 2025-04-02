extends Button

#@onready var sfx_interact_exit = $SFXInteractExit

func _on_exit_pressed():
	#sfx_interact_exit.play()
	call_deferred("exit_game")
	
func exit_game():
	get_tree().quit()
