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
var is_rolling = false
var fire_hold_time = 0.0

@onready var _animation_player = $AnimatedSprite2D

func _physics_process(delta):
	velocity.y += delta * gravity

	if is_attacking or is_rolling:
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
		elif velocity.y > 0:
			_animation_player.play("fall")

		if can_double_jump and Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
			can_double_jump = false
			_animation_player.play("jump")

	# Attack (Normal, Skill & Special)
	if Input.is_action_just_pressed("fire") and not is_attacking and not is_landing and not was_in_air and not is_rolling:
		fire_hold_time = 0.0
		is_attacking = true
		_play_attack("normal_atk")

	if Input.is_action_pressed("fire") and is_attacking:
		fire_hold_time += delta

		# Jika fire ditahan ≥ 3.0 detik, jalankan special_atk
		if fire_hold_time >= 3.0 and _animation_player.animation == "skill_atk":
			_play_attack("special_atk")

		# Jika fire ditahan ≥ 0.6 detik (dan belum mencapai 3.0 detik), jalankan skill_atk
		elif fire_hold_time >= 0.6 and _animation_player.animation == "normal_atk":
			_play_attack("skill_atk")

	if Input.is_action_just_released("fire"):
		is_attacking = false
		fire_hold_time = 0.0
		_animation_player.play("idle")

	# Roll (Sekali setiap kali tombol ditekan)
	if Input.is_action_just_pressed("roll") and not is_rolling and not is_attacking and not was_in_air and not is_landing:
		is_rolling = true
		_play_roll()

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
	velocity.x = 0
	_animation_player.play(anim_name)
	await _animation_player.animation_finished

	if Input.is_action_pressed("fire"):
		# Ulangi dari normal_atk setelah special_atk
		if anim_name == "special_atk":
			fire_hold_time = 0.0
			_play_attack("normal_atk")
	else:
		is_attacking = false
		fire_hold_time = 0.0
		_animation_player.play("idle")

func _play_roll():
	var direction = -1 if _animation_player.flip_h else 1
	_animation_player.play("roll")

	var roll_end_time = Time.get_ticks_msec() + 0.4 * 1000
	while Time.get_ticks_msec() < roll_end_time:
		velocity.x = direction * roll_speed
		move_and_slide()
		await get_tree().process_frame

	is_rolling = false
	velocity.x = 0
	_animation_player.play("idle")
