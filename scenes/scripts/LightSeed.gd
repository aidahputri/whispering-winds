extends Area2D

@onready var sfx_collected = $SFXCollected

func _on_body_entered(body):
	if body.name == "Knight":
		sfx_collected.play()
		await sfx_collected.finished
		Global.add_light_seed()
		queue_free()
