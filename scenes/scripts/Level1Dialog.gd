extends NinePatchRect

@onready var char_box = $CharacterBox
@onready var label_character = $CharacterBox/LabelCharacter
@onready var label_dialog = $LabelDialog
@onready var next_button = $NextButton

var dialog_data = {
	"trigger1": [
		{"character": "", "text": "Aeria steps into what was once a lush forest—now, only withered branches and cracked earth remain."},
		{"character": "", "text": "The air is heavy and still, with faint gusts of wind swirling through the dead landscape."},
		{"character": "Aeria", "text": "Where am I supposed to go? Everything feels... so unfamiliar."},
		{"character": "Anemoi", "text": "Follow the path ahead. In the face of uncertainty, the wind shall reveal what you cannot see."},
		#{"character": "", "text": ""},
	],
	"trigger2": [
		{"character": "Aeria", "text": "These crystals… they feel like fragments of the wind’s power. Maybe they can help me cross these impossible gaps."},
		{"character": "", "text": "A chill breeze stirs the air as the Wind Spirit’s voice echoes softly."},
		{"character": "Anemoi", "text": "The wind’s power lies scattered. Seek the Three Aerolites hidden within this broken land."},
		{"character": "Anemoi", "text": "When gathered, they will grant you the power to leap farther—but be swift, child of Zephira, for their strength fades within 5 seconds."},
	],
}

var current_dialog = []
var current_index = 0
var typing_speed = 0.07
var is_typing = false
var skip_typing = false

func start_dialog(trigger_name):
	print("Memulai dialog untuk:", trigger_name)  # Debug log
	print("Status dialog sebelumnya:", Global.dialog_seen.get(trigger_name, false)) 
	
	if dialog_data.has(trigger_name) and not Global.dialog_seen.get(trigger_name, false):
		current_dialog = dialog_data[trigger_name]
		current_index = 0
		Global.is_dialog_active = true
		Global.dialog_seen[trigger_name] = true
		show_dialog()

func show_dialog():
	if current_index < current_dialog.size():
		visible = true
		var dialog = current_dialog[current_index]
		label_dialog.text = dialog["text"]

		if dialog["character"] != "":
			label_character.text = dialog["character"]
			char_box.show()
		else:
			char_box.hide()

		await type_text(dialog["text"])
	else:
		visible = false
		current_dialog.clear()
		Global.is_dialog_active = false

func _on_next_button_pressed():
	if is_typing:
		skip_typing = true
	else:
		current_index += 1
		show_dialog()

func type_text(text: String):
	is_typing = true
	skip_typing = false
	label_dialog.text = ""
	for i in range(text.length()):
		if skip_typing:
			label_dialog.text = text
			break
		label_dialog.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false

func _on_area_trigger_1_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		print("Masuk ke area dialog 1")
		start_dialog("trigger1")

func _on_area_trigger_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Masuk ke area dialog 2")
		start_dialog("trigger2")
