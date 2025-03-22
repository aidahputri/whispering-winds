extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var dash_speed = 400
@export var jump_speed = -150
@export var roll_speed = 300
@export var roll_distance = 100 
@export var can_double_jump = false

var was_in_air = false
var is_landing = false
var is_attacking = false
var fire_hold_time = 0.0
var input_queue = []

@onready var _animation_player = $AnimatedSprite2D

func _physics_process(delta):
	velocity.y += delta * gravity

	if is_attacking:
		velocity.x = 0
	else:
		_handle_movement()

	# Lompat
	if is_on_floor():
		if was_in_air:
			is_landing = true
			was_in_air = false
			await get_tree().create_timer(0.1).timeout
			is_landing = false

		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
			can_double_jump = true
			_animation_player.play("jump")
			was_in_air = true

	elif not is_on_floor():
		if velocity.y < 0:
			_animation_player.play("jump")

		if can_double_jump and Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
			can_double_jump = false
			_animation_player.play("jump")

	# Attack (Normal, Skill & Special)
	if Input.is_action_just_pressed("fire") and not is_attacking and not is_landing and not was_in_air:
		input_queue.append("fire")

	if not is_attacking and input_queue.size() > 0:
		var next_attack = input_queue.pop_front()
		if next_attack == "fire":
			_play_attack("normal_atk")

	# Hold-release system
	if is_attacking and Input.is_action_pressed("fire"):
		fire_hold_time += delta

		if fire_hold_time >= 1.0 and _animation_player.animation == "skill_atk":
			_play_attack("special_atk")
		elif fire_hold_time >= 0.3 and _animation_player.animation == "normal_atk":
			_play_attack("skill_atk")
		
	if Input.is_action_just_released("fire"):
		fire_hold_time = 0.0
		input_queue.clear()
		is_attacking = false
		_animation_player.play("idle")

	move_and_slide()

func _handle_movement():
	var speed = dash_speed if Input.is_action_pressed("dash") else walk_speed

	if Input.is_action_pressed("left"):
		velocity.x = -speed
		_animation_player.flip_h = true
		_play_walk_or_run()

	elif Input.is_action_pressed("right"):
		velocity.x = speed
		_animation_player.flip_h = false
		_play_walk_or_run()

	else:
		velocity.x = 0
		if is_on_floor() and not was_in_air and not is_landing:
			_animation_player.play("idle")

func _play_walk_or_run():
	if is_on_floor():
		if Input.is_action_pressed("dash"):
			_animation_player.play("run")
		else:
			_animation_player.play("walk")

func _play_attack(anim_name: String):
	is_attacking = true
	velocity.x = 0
	_animation_player.play(anim_name)
	 # Attack canceling: Bisa di-cancel setelah 0.2 detik
	await get_tree().create_timer(0.2).timeout

	if Input.is_action_pressed("fire"):
		if anim_name == "normal_atk":
			_play_attack("skill_atk")
		elif anim_name == "skill_atk":
			_play_attack("special_atk")

	await _animation_player.animation_finished

	is_attacking = false
	fire_hold_time = 0.0
	input_queue.clear()
	_animation_player.play("idle")
