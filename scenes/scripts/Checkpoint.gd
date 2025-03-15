extends Area2D

var player_in_area = null

func _on_body_entered(body):
	if body.name == "Player":
		print("Masuk ke area checkpoint, tekan 'F' untuk klaim.")
		player_in_area = body

func _on_body_exited(body):
	if body == player_in_area:
		player_in_area = null

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		print("Checkpoint diklaim!")
		player_in_area.claim_checkpoint(global_position)
