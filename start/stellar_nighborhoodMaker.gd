extends PanelContainer


@export var main:Control
var nighborhoodsize
func _on_line_edit_value_changed(value: float) -> void:
	nighborhoodsize=value
	main.nbrhdRadius= value
	

func _on_location_2_value_changed(value: float) -> void:
	if Global.is_in_range(main.galaxyHabitableZoneMin,main.galaxyHabitableZoneMax,value):
		main.nignhborhoodLocation=value
		$VBoxContainer/Location/Warning.visible=false

	else:
		$VBoxContainer/Location/location2.value=0
		$VBoxContainer/Location/Warning.visible=true
		$VBoxContainer/Location/Warning.text=str("Location not in habitable zone. habitable zone: ",main.galaxyHabitableZoneMin," - ", main.galaxyHabitableZoneMax)
		await get_tree().create_timer(3).timeout
		$VBoxContainer/Location/Warning.visible=false
