extends Camera2D

var shake_amount = 0.0
var shake_decay = 5.0

func _process(delta):
	if shake_amount > 0.0:
		offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		shake_amount = lerp(shake_amount, 0.0, delta * shake_decay)
	else:
		offset = Vector2.ZERO

func start_shake(amount: float):
	shake_amount = amount
