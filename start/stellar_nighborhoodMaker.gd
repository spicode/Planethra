extends PanelContainer


@export var main:Control
var nighborhoodsize=10
var nieghborhood_density=0.003
var nieghborhood=StellarNighborhood.new()
func _on_line_edit_value_changed(value: float) -> void:
	nighborhoodsize=value
	main.nbrhdRadius= value
	nieghborhood=nieghborhood.classify_stellar_nieghborhood(nieghborhood_density,nighborhoodsize)

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
		
func updateNieghborhood():
	$VBoxContainer/FoldableContainer/VBoxContainer/O/NUMBER.text=nieghborhood.O
	$VBoxContainer/FoldableContainer/VBoxContainer/B/NUMBER.text=nieghborhood.B
	$VBoxContainer/FoldableContainer/VBoxContainer/A/NUMBER.text=nieghborhood.A
	$VBoxContainer/FoldableContainer/VBoxContainer/F/NUMBER.text=nieghborhood.F
	$VBoxContainer/FoldableContainer/VBoxContainer/G/NUMBER.text=nieghborhood.G
	$VBoxContainer/FoldableContainer/VBoxContainer/K/NUMBER.text=nieghborhood.K
	$VBoxContainer/FoldableContainer/VBoxContainer/M/NUMBER.text=nieghborhood.M
	$VBoxContainer/FoldableContainer/VBoxContainer/D/NUMBER.text=nieghborhood.D
	$VBoxContainer/FoldableContainer/VBoxContainer/LTY/NUMBER.text=nieghborhood.LTY
	$VBoxContainer/FoldableContainer/VBoxContainer/Other/NUMBER.text=nieghborhood.other

func _on_stellar_density_2_value_changed(value: float) -> void:
	nieghborhood_density=value
	main.nbrhddnsity= value
	nieghborhood=nieghborhood.classify_stellar_nieghborhood(nieghborhood_density,nighborhoodsize)
