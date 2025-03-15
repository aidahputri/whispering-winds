extends CharacterBody2D

@export var SPEED = 200
@export var JUMP_SPEED = 500
@export var JUMP_GRAVITY = 1500
@export var JUMP_DISTANCE = 20

@onready var animplayer = $AnimatedSprite2D
@onready var aerolite = $Aerolite
@onready var aerocryst = $Aerocryst

var z_position = 0.0
var z_velocity = 0.0
var is_jumping = false
var landed_safely = true
var jump_direction = Vector2.ZERO

func _get_input():
	var direction_x = Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")
	var animation = "idle"

	if Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		z_velocity = -JUMP_SPEED
		jump_direction = Vector2(direction_x, direction_y).normalized() * JUMP_DISTANCE
		animation = "walk_down" 

	if direction_x:
		velocity.x = direction_x * SPEED
		if direction_x > 0:
			animation = "walk_right"
		else:
			animation = "walk_left"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_y:
		velocity.y = direction_y * SPEED
		if direction_y < 0:
			animation = "walk_up"
		else:
			animation = "walk_down"
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	animplayer.play(animation)

func _physics_process(delta: float) -> void:
	if is_jumping:
		z_velocity += JUMP_GRAVITY * delta
		z_position += z_velocity * delta
		position += jump_direction * delta

		if z_position >= 0:
			z_position = 0
			is_jumping = false
			
			if not landed_safely:
				print("Jatuh ke jurang! Reload level.")
				refresh_scene()

	_get_input()
	if is_instance_valid(self) and is_inside_tree():
		move_and_slide()

	animplayer.scale = Vector2(1, 1) - Vector2(0.4, 0.4) * (z_position / JUMP_SPEED)
	animplayer.position.y = -z_position * 0.5

func _on_death_area_body_entered(body: Node2D):
	if body.name == "Player":
		landed_safely = false
		if not is_jumping:
			call_deferred("refresh_scene")

func _on_death_area_body_exited(body: Node2D):
	if body.name == "Player":
		landed_safely = true

func refresh_scene():
	get_tree().reload_current_scene()

func _on_ground_area_body_entered(body: Node2D):
	if body.name == "Player":
		landed_safely = true
		print("Mendarat di Ground Area")

func _on_wind_activated() -> void:
	print("jump speed inreased!")
	JUMP_DISTANCE = 200
	aerolite.visible = true

func _on_wind_deactivated() -> void:
	JUMP_DISTANCE = 20
	aerolite.visible = false

func _on_wind_orb_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		aerocryst.visible = true
		JUMP_DISTANCE = 300
