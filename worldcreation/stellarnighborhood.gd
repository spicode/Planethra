extends Node3D

@export var stars : Array[StellarSystem]
func _ready() -> void:
	stars=Global.nieborhood.stars
	for system in stars:
		var systemLocation=system.Location
		for star in system.Stars:
			var starNode:=MeshInstance3D.new()
			starNode.mesh=SphereMesh.new()
			var matirial=StandardMaterial3D.new()
			matirial.albedo_color= star._color
			starNode.mesh.material = matirial
			starNode.mesh.radius =star.radius
			starNode.mesh.height =star.radius*2
			var starName=str("Star_",system.Stars.find(star))
			starNode.name=starName
			var light=OmniLight3D.new()
			light.light_color=star._color
			light.omni_range=star.lumanucity*100
			light.light_intensity_lumens=star.lumanucity
			var lightName=str("StarLight_",system.Stars.find(star))
			light.name=lightName
			add_child(starNode)
			add_child(light)
			var realStarNode=get_node(starName)
			var realLightNode=get_node(lightName)
			realLightNode.global_position=star.starLocation+systemLocation
			realStarNode.global_position=star.starLocation+systemLocation
			print(realStarNode.global_position)
