extends Node2D

@onready var background = $CanvasLayer/Background
@onready var title_label = $CanvasLayer/Label
@onready var fade_timer = $CanvasLayer/FadeTimer

var fading_in = true
var fading_out = false
var fade_speed = 1.5

func _ready():
	background.modulate.a = 0
	title_label.modulate.a = 0

	fade_timer.wait_time = 2.0
	fade_timer.one_shot = true
	fade_timer.timeout.connect(_on_fade_timer_timeout) 

func _process(delta):
	if fading_in:
		background.modulate.a = min(background.modulate.a + fade_speed * delta, 1)
		title_label.modulate.a = min(title_label.modulate.a + fade_speed * delta, 1)
		
		if background.modulate.a >= 1:
			fading_in = false
			fade_timer.start()

	elif fading_out:
		background.modulate.a = max(background.modulate.a - fade_speed * delta, 0)
		title_label.modulate.a = max(title_label.modulate.a - fade_speed * delta, 0)

		if background.modulate.a <= 0:
			change_scene()

func _on_fade_timer_timeout():
	fade_out()

func fade_out():
	fading_out = true

func change_scene():
	get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")
