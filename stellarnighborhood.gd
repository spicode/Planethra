extends Node3D

@export var stars : Dictionary[Vector3,float]  
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for star in stars.keys():
		var starNode:=CSGSphere3D.new()
		starNode.global_position=star
		var matirial=StandardMaterial3D.new()
		var mass = stars.get(star)
		var radius=  mass^0.8 if mass < 1 else mass^0.57
		var lumanucity = 0.23*mass^2.3 if mass<0.43 else (mass^4 if mass<2 else mass^3.5)
		var density = mass/radius^3
		var temprature =((lumanucity/radius^2)^0.25)*5776
		matirial.albedo_color= Global.Kelvin2Rgb(temprature)
		starNode.material = matirial
		starNode.radius =radius
