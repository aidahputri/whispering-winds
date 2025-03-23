extends CharacterBody2D

@export var max_hp = 30
var hp: int
var is_attacking = false
var is_damaging = false
var target_body = null

@onready var health_bar = $HealthBar
@onready var _animation_player = $Bat
@onready var attack_area = $AttackArea
@onready var timer = $Timer

func _ready():
	hp = max_hp
	health_bar.update_health(hp)
	
func _physics_process(delta: float) -> void:
	if is_attacking and timer.is_stopped():
		_animation_player.play("atk")
		timer.start(0.75)
		if is_damaging and target_body:
			print("damage")
			target_body.take_damage(5)
			
	if not is_attacking:
		_animation_player.play("idle")

func take_damage(amount: int):
	print("here")
	if hp <= 0:
		return
	_animation_player.play("hurt")
	hp -= amount
	health_bar.update_health(hp)

	if hp <= 0:
		die()

func die():
	_animation_player.play("die")
	await _animation_player.animation_finished
	queue_free()

func _on_atk_start_body_entered(body):
	if body.name == "Knight" and not is_attacking:
		is_attacking = true
		
func _on_atk_start_body_exited(body: Node2D) -> void:
	if body.name == "Knight":
		is_attacking = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "Knight" and is_attacking:
		target_body = body
		is_damaging = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.name == "Knight" and is_attacking:
		target_body = null
		is_damaging = false
