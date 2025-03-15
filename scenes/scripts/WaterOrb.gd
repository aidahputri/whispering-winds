extends Area2D

@onready var water = $Water
var player_in_area = null

func _on_body_entered(body):
	if body.name == "Player":
		print("Tekan 'F' untuk mengaktifkan mekanisme")
		player_in_area = body

#func _on_body_exited(body):
	#if body == player_in_area:
		#player_in_area = null
		#visible = false

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		water.visible = true
		
	if player_in_area and Input.is_action_just_pressed("fire") and player_in_area.has_method("start_slide"):
		var slide_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
			
		if slide_direction == Vector2.ZERO:
			slide_direction = Vector2(0, 1)
			
		player_in_area.start_slide(slide_direction)
