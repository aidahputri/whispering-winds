extends Area2D

@onready var water = $Water
@onready var slide_bubble = $SlideArea
var player_in_area_water = null
var player_in_area_slide = null

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Tekan 'F' untuk mengaktifkan mekanisme")
		player_in_area_water = body
	
func _on_slide_area_2_body_entered(body: Node2D):
	if body.name == "Player":
		print("Tekan 'J' untuk mengaktifkan mekanisme")
		player_in_area_slide = body

func _process(_delta):
	if player_in_area_water and Input.is_action_just_pressed("interact"):
		water.visible = true
		slide_bubble.visible = true
		Global.set_water_orb_status(true)
		
	if player_in_area_slide and Global.is_waterorb_active and Input.is_action_just_pressed("fire") and player_in_area_slide.has_method("start_slide"):
		var slide_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
			
		if slide_direction == Vector2.ZERO:
			slide_direction = Vector2(0, 1)
			
		player_in_area_slide.start_slide(slide_direction)
