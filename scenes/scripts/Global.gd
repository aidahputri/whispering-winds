extends Node

var is_dialog_active: bool = false
var is_waterorb_active: bool = false
var is_wind_orb_entered: bool = false
var dialog_seen = {}
var collected_count := 0
var max_aerolite := 3
var wind_active := false
var wind_timer := 0

# Tambahan HP
var max_hp := 100
var current_hp := 100

signal collected_count_updated(current: int, max: int)
signal wind_countdown_updated(time_left: int)
signal wind_orb_status_updated
signal water_orb_status_updated
signal hp_updated(current_hp: int, max_hp: int)

func set_current_hp(value: int):
	current_hp = value
	hp_updated.emit(current_hp, max_hp)

func update_collected_count(count: int):
	collected_count = count
	collected_count_updated.emit(collected_count, max_aerolite)
	
func reset_collected_count():
	collected_count = 0
	collected_count_updated.emit(collected_count, max_aerolite)

func start_wind_countdown(duration: int):
	wind_active = true
	wind_timer = duration
	while wind_timer > 0:
		wind_countdown_updated.emit(wind_timer)
		await get_tree().create_timer(1.0).timeout
		wind_timer -= 1
	wind_active = false
	wind_countdown_updated.emit(0)
	
func set_wind_orb_status(value: bool):
	is_wind_orb_entered = value
	wind_orb_status_updated.emit(value)

func set_water_orb_status(value: bool):
	is_waterorb_active = value
	water_orb_status_updated.emit(value)
