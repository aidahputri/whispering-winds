extends Node2D

@export var target_scene: String = ""

@onready var background = $CanvasLayer/Background
@onready var title_label = $CanvasLayer/Label
@onready var fade_timer = $CanvasLayer/FadeTimer

var fading_in = true
var fading_out = false
var fade_speed = 1.5

var epilog_text = [
	"As the final Seed of Light merges into the Spiritus, a brilliant radiance engulfs the ruins, washing away the lingering darkness.",
	"The once-faded land stirs back to life, the wind and water flowing freely once more, as if the world itself breathes again.",
	"Aeria takes a deep breath, feeling the warmth of the light—this chapter has ended, but the echoes of his journey will forever remain.",
	"The End."
]

var current_text_index = 0
var text_change_timer = 1.0 # Change text every 1 second

func _ready():
	background.modulate.a = 0
	title_label.modulate.a = 0

	fade_timer.wait_time = 2.0
	fade_timer.one_shot = true
	fade_timer.timeout.connect(_on_fade_timer_timeout) 

	# Start the fade-in effect
	fading_in = true
	fade_timer.start()

	# Wait for the fade-in to complete, then start the epilogue text
	await get_tree().create_timer(2.0).timeout
	start_epilogue_text()

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
	get_tree().change_scene_to_file("res://scenes/levels/" + target_scene + ".tscn")

# Start updating the epilogue text at regular intervals
func start_epilogue_text():
	var timer = get_tree().create_timer(text_change_timer)
	timer.timeout.connect(self, "_on_text_change_timeout")

func _on_text_change_timeout():
	if current_text_index < epilog_text.size():
		title_label.text = epilog_text[current_text_index]
		current_text_index += 1
	else:
		# After showing "The End", stop the fade out
		fading_out = false
		# Optional: If you want to trigger the scene change after the text is fully shown, uncomment this line
		# change_scene()
