extends PanelContainer

@export var main:Control
func _on_line_edit_value_changed(value: float) -> void:
	var galsize=value
	$VBoxContainer/Container2/Label4.text = str(round(galsize*0.47)," - ",round(galsize*0.6))
	main.galaxyHabitableZoneMin=round(galsize*0.47)
	main.galaxyHabitableZoneMax=round(galsize*0.6)
	main.galaxySize=galsize
