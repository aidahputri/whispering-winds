extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var dash_speed = 400
@export var jump_speed = -150
@export var can_double_jump = false
@export var max_hp = 100

var hp: int
var was_in_air = false
var is_landing = false
var is_attacking = false
var fire_hold_time = 0.0
var input_queue = []

@onready var _animation_player = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var attack_area_right = $AttackAreaRight
@onready var attack_area_left = $AttackAreaLeft

func _ready():
	hp = max_hp
	health_bar.update_health(hp)
	attack_area_left.monitoring = false 
	attack_area_right.monitoring = false 
	
func _physics_process(delta):
	velocity.y += delta * gravity
	
	#if is_on_floor() and is_attacking:
		#is_attacking = false
		#attack_area.monitoring = false
		#_animation_player.play("idle")

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
			is_attacking = false

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
	if Input.is_action_just_pressed("fire") and not is_attacking:
		_play_attack("special_atk")
		
	move_and_slide()

func _handle_movement():
	if hp > 0:
		var speed = dash_speed if Input.is_action_pressed("dash") else walk_speed

		if Input.is_action_pressed("left"):
			velocity.x = -speed
			_animation_player.flip_h = true
			attack_area_left.visible = true
			attack_area_right.visible = false
			_play_walk_or_run()

		elif Input.is_action_pressed("right"):
			velocity.x = speed
			_animation_player.flip_h = false
			attack_area_left.visible = false
			attack_area_right.visible = true
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
	if hp > 0:
		is_attacking = true
		velocity.x = 0
		attack_area_left.monitoring = true
		attack_area_right.monitoring = true
		_animation_player.play(anim_name)
		
		 # Attack canceling: Bisa di-cancel setelah 0.2 detik
		await get_tree().create_timer(0.2).timeout

		await _animation_player.animation_finished

		attack_area_left.monitoring = false
		attack_area_right.monitoring = false
		is_attacking = false
		_animation_player.play("idle")
	
func take_damage(amount: int):
	if hp > 0:
		hp -= amount
		health_bar.update_health(hp)
		Global.set_current_hp(max(0, Global.current_hp - amount))
		if hp <= 0:
			die()

func die():
	_animation_player.play("death")
	await _animation_player.animation_finished
	queue_free()
	
func _on_attack_area_body_entered(body):
	#if is_attacking and body.name in ['Bat', 'Slime']:
	#print(get_tree().get_nodes_in_group("slime"))
	print(body)
	if is_attacking and (body.name.contains("Bat") or body.is_in_group("slime")):
		#print(body.name)
		body.take_damage(5)
