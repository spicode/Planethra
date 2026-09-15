extends Camera3D
@export var speed = 20
@export var senstivty=1000


func _process(delta: float) -> void:
	
	if Input.is_action_pressed("scrollUp"):
		speed+=3
		print("speed UP")
	if Input.is_action_pressed("scrollDown"):
		print("speed UP")
		speed-=3
	if Input.is_action_pressed("up"):
		global_position.y+=speed*delta
	elif Input.is_action_pressed("down"):
		global_position.y-=speed*delta
	if Input.is_action_pressed("forwards"):
		global_position.z-=speed*delta
	if Input.is_action_pressed("backwards"):
		global_position.z+=speed*delta
	if Input.is_action_pressed("left"):
		global_position.x-=speed*delta
	if Input.is_action_pressed("right"):
		global_position.x+=speed*delta
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var senstivtyAngle= pow(senstivty,-1)
		rotate_object_local(Vector3.UP,-event.relative.x*senstivtyAngle)
		rotate_object_local(Vector3.LEFT,event.relative.y*senstivtyAngle)
func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	
