extends Control
func _enter_tree() -> void:
	Global.activeScene="World"
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
var galaxySize:=0.0
var nieghborhoodSize 
var starAmount
var galaxyHabitableZoneMin
var galaxyHabitableZoneMax
var nignhborhoodLocation
var nbrhdRadius
var nbrhddnsity
