extends Camera2D
var isDragging
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: #dragging logic
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position-=event.relative
