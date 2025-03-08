extends Node2D

@onready var bg_texture = $Background
@onready var anim_player = $AnimationPlayer
@onready var char_box = $DialogBox/CharacterBox
@onready var label_character = $DialogBox/CharacterBox/LabelCharacter
@onready var label_dialog = $DialogBox/LabelDialog
@onready var next_button = $DialogBox/NextButton

var dialog_data = [
	{"character": "", "text": "This world was once full of life. The gentle breeze, the flowing rivers, the golden light that danced through the trees… But now, everything is fading.", "bg": "res://assets/background/start1.png"},
	{"character": "", "text": "The shadows have begun to emerge from the Spiritus Rift, consuming the essence of nature, leaving destruction in their wake like a spreading poison."},
	{"character": "", "text": "But hope is not yet lost… Someone has been chosen.", "bg": "res://assets/background/start2.png"},
	{"character": "", "text": "In a long-forgotten shrine, a boy awakens. He does not remember how he got here. Only the sound of the wind whispers to him, calling his name..."},
	{"character": "", "text": "Aeria."},
]
var current_index = 0
var typing_speed = 0.1
var is_typing = false

func _ready():
	show_dialog()
	
func show_dialog():
	if current_index < dialog_data.size():
		var current_dialog = dialog_data[current_index]
		
		label_dialog.text = current_dialog["text"]

		if current_dialog["character"] != "":
			label_character.text = current_dialog["character"]
			label_character.show()
		else:
			char_box.hide()

		if "bg" in current_dialog:
			if current_index > 0 and "bg" in dialog_data[current_index - 1]: 
				if current_dialog["bg"] != dialog_data[current_index - 1]["bg"]:
					anim_player.play("fade_out")
					await anim_player.animation_finished
			
			bg_texture.texture = load(current_dialog["bg"])
			anim_player.play("fade_in")
		
		await type_text(current_dialog["text"])
	else:
		queue_free()

func _on_next_button_pressed():
	if is_typing:
		label_dialog.text = dialog_data[current_index]["text"]
		is_typing = false
	else:
		current_index += 1
		show_dialog()

func type_text(text: String):
	is_typing = true
	label_dialog.text = ""
	for i in range(text.length()):
		label_dialog.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false
