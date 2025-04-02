extends Node2D

@export var knight: CharacterBody2D = null
@onready var hp_label = $HPLabel
@onready var light_seed_label = $LightLabel

func _ready():
	Global.light_seeds_updated.connect(update_light_seed_text)
	
	update()
	
func _process(delta: float) -> void:
	update()

func update():
	if knight != null:
		update_hp_display(knight.hp, knight.max_hp)
	
	update_light_seed_text(Global.total_light_seeds, Global.max_light_seeds)
	
	#Global.hp_updated.connect(update_hp_display)

func update_hp_display(current_hp: int, max_hp: int):
	hp_label.text = "%d/%d" % [current_hp, max_hp]
	
func update_light_seed_text(total_light_seeds: int, max_light_seeds: int):
	light_seed_label.text = "%d/%d" % [total_light_seeds, max_light_seeds]
