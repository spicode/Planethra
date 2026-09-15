extends Camera3D
@export var speed = 20
@export var senstivty=1000


func _process(delta: float) -> void:
	$"../Control/sensitivity".text=str('sensitivty:',senstivty)
	senstivty= $"../Control/sensitivtyy".value
	$"../Control/speed".text=str('speed=',speed," use scroll wheel to change")
	var move := Vector3.ZERO
	if Input.is_action_pressed("forwards"):
		move -= transform.basis.z   # camera looks down -Z
	if Input.is_action_pressed("backwards"):
		move += transform.basis.z
	if Input.is_action_pressed("left"):
		move -= transform.basis.x
	if Input.is_action_pressed("right"):
		move += transform.basis.x
	if Input.is_action_pressed("up"):
		move += transform.basis.y
	if Input.is_action_pressed("down"):
		move -= transform.basis.y

	if move != Vector3.ZERO:
		global_position += move.normalized() * speed * delta
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var senstivtyAngle= pow(senstivty,-1)
		rotate_object_local(Vector3.UP,-event.relative.x*senstivtyAngle)
		rotate_object_local(Vector3.LEFT,event.relative.y*senstivtyAngle)
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			speed += 3
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			speed -= 3
func _ready() -> void:
	Input.mouse_mode= Input.MOUSE_MODE_CAPTURED
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
