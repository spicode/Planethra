extends Panel

func _ready() -> void:
	if Global.activeScene=="Evolution tree":
		$Evolution.disabled=true
	if Global.activeScene=="Editor":
		$Editor.disabled=true
	if Global.activeScene=="Notes":
		$Notes.disabled=true
	if Global.activeScene=="World":
		$World.disabled=true


func _on_world_pressed() -> void:
	get_tree().change_scene_to_file("res://start/start.tscn")


func _on_editor_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/editor.tscn")


func _on_evolution_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/main.tscn")


func _on_notes_pressed() -> void:
	get_tree().change_scene_to_file("res://doc.tscn")
