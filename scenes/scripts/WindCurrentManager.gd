extends Node2D

signal wind_activated
signal wind_deactivated

@export var wind_boost := 1000
@onready var timer = $Timer

var collected_count := 0
var wind_active := false

func on_aerolite_collected():
	if wind_active:
		print("Wind Current aktif, Aerolite diabaikan.")
		return
	
	collected_count += 1
	print("Aerolite dikumpulkan: ", collected_count)

	if collected_count >= 3:
		activate_wind_current()

func activate_wind_current():
	if wind_active:
		return
	print("Wind Current Aktif!")
	wind_active = true
	collected_count = 0
	
	wind_activated.emit()

	timer.start(3)

func _on_timer_timeout():
	print("Wind Current Nonaktif!")
	wind_active = false
	
	wind_deactivated.emit()
