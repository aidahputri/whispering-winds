extends Node2D

@export var wind_boost := 1000
@onready var timer = $Timer

var collected_count := 0
var wind_active := false

func _ready():
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func on_aerolite_collected():
	if wind_active:
		return
	collected_count += 1
	
	if collected_count >= 3:
		activate_wind_current()

func activate_wind_current():
	print("Wind Current Aktif!")
	wind_active = true
	collected_count = 0
	timer.start(10)

func _on_timer_timeout():
	print("Wind Current Nonaktif!")
	wind_active = false
