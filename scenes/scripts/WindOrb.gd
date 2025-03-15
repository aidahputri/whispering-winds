extends Area2D

#@onready var animplayer = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#animplayer.play("idle")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		visible = false
