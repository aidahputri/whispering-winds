extends CharacterBody2D

@export var SPEED := 200
@export var JUMP_SPEED := -400
@export var GRAVITY := 1200
@onready var animplayer = $AnimatedSprite2D

const UP = Vector2(0,-1)

func _get_input():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_SPEED

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")  # Tambahkan gerakan vertikal
	var animation = "idle"
	
	# Animasi right n left
	if direction_x:
		velocity.x = direction_x * SPEED
		if direction_x > 0:
			animation = "walk_right"
		else:
			animation = "walk_left"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Animasi up n down
	if direction_y:
		velocity.y = direction_y * SPEED
		if direction_y < 0:
			animation = "walk_up"
		else:
			animation = "walk_down"	
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	animplayer.play(animation)
	move_and_slide()


func _physics_process(delta: float) -> void:
	velocity.y += delta*GRAVITY
	_get_input()
	move_and_slide()
