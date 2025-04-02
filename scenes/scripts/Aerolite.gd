extends Area2D

signal aerolite_collected

var initial_position

@onready var animplayer = $AnimatedSprite2D
@onready var sfx_collected = $SFXCollected

func _ready():
	initial_position = global_position
	animplayer.play("idle")

func _on_body_entered(body):
	if body.name == "Player":
		print("Aerolite dikumpulkan!")
		sfx_collected.play()
		emit_signal("aerolite_collected")
		visible = false
		get_tree().create_timer(5).connect("timeout", Callable(self, "respawn"))

func respawn():
	global_position = initial_position
	visible = true
