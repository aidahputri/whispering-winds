extends Node2D

@onready var aerolite_label = $AeroliteLabel
@onready var wind_timer_label = $WindTimerLabel
@onready var aerocryst_icon = $AerocrystIcon
@onready var water_icon = $WaterIcon

func _ready():
	update_aerolite_display(0, Global.max_aerolite)
	update_aerocryst_icon(Global.is_wind_orb_entered)
	update_water_icon(Global.is_waterorb_active)
	
	Global.collected_count_updated.connect(update_aerolite_display)
	Global.wind_countdown_updated.connect(update_wind_timer)
	Global.wind_orb_status_updated.connect(update_aerocryst_icon)
	Global.water_orb_status_updated.connect(update_water_icon)

func update_aerolite_display(current: int, max: int):
	aerolite_label.text = "%d/%d" % [current, max]

func update_wind_timer(time_left: int):
	if time_left > 0:
		wind_timer_label.text = "(%ds)" % time_left
	else:
		wind_timer_label.text = ""
		
func update_aerocryst_icon(is_active: bool):
	aerocryst_icon.visible = is_active

func update_water_icon(is_active: bool):
	water_icon.visible = is_active
