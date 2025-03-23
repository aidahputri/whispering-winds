extends Control

@export var max_health: int = 100
var current_health: int

@onready var progress_bar = $ProgressBar

func _ready():
	current_health = max_health
	progress_bar.max_value = max_health
	progress_bar.value = current_health

func update_health(new_health: int):
	current_health = max(new_health, 0)
	progress_bar.value = current_health
