extends Node2D

@onready var hp_label = $HPLabel

func _ready():
	Global.hp_updated.connect(update_hp_display)
	update_hp_display(Global.current_hp, Global.max_hp)

func update_hp_display(current_hp: int, max_hp: int):
	hp_label.text = "%d/%d" % [current_hp, max_hp]
