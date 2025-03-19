extends Area2D

@export var claim: bool = false
var player_in_area = null

@onready var label = $NinePatchRect/Label

func _ready():
	update_label()

func _on_body_entered(body):
	if body.name == "Player":
		print("Masuk ke area checkpoint, tekan 'F' untuk klaim.")
		player_in_area = body
		update_label()

func _on_body_exited(body):
	if body == player_in_area:
		player_in_area = null

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interact") and not claim:
		print("Checkpoint diklaim!")
		player_in_area.claim_checkpoint(global_position)
		claim = true
		update_label()

func update_label():
	if claim:
		label.text = "Claimed!"
	else:
		label.text = "Click F to Claim"
