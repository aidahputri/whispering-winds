extends Area2D

@onready var sfx_collected = $SFXCollected
@onready var bubble = $NinePatchRect
var can_interact = false

func _ready():
	visible = false  # Awalnya tersembunyi
	Global.light_seeds_updated.connect(update_visibility)
	update_visibility(Global.total_light_seeds, Global.max_light_seeds)

func update_visibility(current: int, max: int):
	visible = current >= max
		
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Knight" and visible:
		bubble.visible = true
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Knight":
		bubble.visible = false
		can_interact = false

func _process(delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		sfx_collected.play()
		get_tree().change_scene_to_file("res://scenes/cutscenes/Epilogue.tscn")
