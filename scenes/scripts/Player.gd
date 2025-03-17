extends CharacterBody2D

@export var SPEED = 200
@export var SLIDE_SPEED = 400
@export var JUMP_SPEED = 500
@export var JUMP_GRAVITY = 1500
@export var JUMP_DISTANCE = 20

@onready var animplayer = $AnimatedSprite2D
@onready var aerolite = $Aerolite
@onready var aerocryst = $Aerocryst
@onready var slide_timer = $SlideTimer

var last_checkpoint_position: Vector2 = Vector2.ZERO
var has_checkpoint = false

var z_position = 0.0
var z_velocity = 0.0
var is_jumping = false
var landed_safely = true
var jump_direction = Vector2.ZERO

var is_sliding = false
var water_slide_duration = 20.0
var slide_direction = Vector2(0, 1)
var can_change_direction = false 
	
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
	if Global.is_dialog_active:
		velocity = Vector2.ZERO
		animplayer.play("idle")
		return
		
	if is_jumping:
		z_velocity += JUMP_GRAVITY * delta
		z_position += z_velocity * delta
		position += jump_direction * delta

		if z_position >= 0:
			z_position = 0
			is_jumping = false
			
			if not landed_safely and not is_sliding:
				respawn()

	if is_sliding:
		velocity = slide_direction * SLIDE_SPEED

		var collision = move_and_collide(velocity * delta)
		if collision:
			var normal = collision.get_normal()
			print("Menabrak! Arah baru: ", slide_direction)
			can_change_direction = true
			
		if can_change_direction:
			var new_input = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
			if new_input != Vector2.ZERO:
				slide_direction = new_input.normalized()
				can_change_direction = false
				print("Arah berubah menjadi: ", slide_direction)
				
	else:
		_get_input()
		
	if is_instance_valid(self) and is_inside_tree():
		move_and_slide()

	animplayer.scale = Vector2(1, 1) - Vector2(0.4, 0.4) * (z_position / JUMP_SPEED)
	animplayer.position.y = -z_position * 0.5
	
func claim_checkpoint(position: Vector2):
	print("Memproses checkpoint. Diterima: ", position)
	last_checkpoint_position = position
	has_checkpoint = true
	print("Checkpoint diklaim di: ", last_checkpoint_position)

func respawn():
	if has_checkpoint:
		print("Respawn di checkpoint terakhir!")
		global_position = last_checkpoint_position
	else:
		print("Tidak ada checkpoint, mengulang level!")
		call_deferred("refresh_scene")

func _on_death_area_body_entered(body: Node2D):
	if body.name == "Player" and not is_sliding:
		landed_safely = false
		if not is_jumping:
			respawn()

func _on_death_area_body_exited(body: Node2D):
	if body.name == "Player":
		landed_safely = true

func refresh_scene():
	get_tree().reload_current_scene()

func _on_ground_area_body_entered(body: Node2D):
	if body.name == "Player":
		landed_safely = true
		is_sliding = false
		print("Mendarat di Ground Area")

func _on_wind_activated() -> void:
	if not aerocryst.visible:
		print("jump speed inreased!")
		JUMP_DISTANCE = 200
		aerolite.visible = true

func _on_wind_deactivated() -> void:
	if not aerocryst.visible:
		JUMP_DISTANCE = 20
		aerolite.visible = false

func _on_wind_orb_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not aerocryst.visible:
		aerocryst.visible = true
		JUMP_DISTANCE = 300

func enable_water_slide():
	print("Water Slide Aktif!")
	is_sliding = true
	can_change_direction = false
	slide_timer.start()
	
func start_slide(direction: Vector2):
	if not is_sliding:
		enable_water_slide()
	
	slide_direction = direction.normalized() if direction != Vector2.ZERO else Vector2(0, 1)
	
func stop_slide():
	print("Slide dihentikan karena menyentuh ground!")
	is_sliding = false
	velocity = Vector2.ZERO

func _on_water_barrier_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		landed_safely = false
		if not is_jumping:
			respawn()
