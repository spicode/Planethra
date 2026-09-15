extends Node3D

@export var stars : Array[StellarSystem]
func _ready() -> void:
	stars=Global.nieborhood.stars
	for system in stars:
		var systemLocation=system.Location
		for star_i in system.Stars.size():
			var star = system.Stars[star_i]
			var starNode:=MeshInstance3D.new()
			starNode.mesh=SphereMesh.new()
			var matirial = StandardMaterial3D.new()
			matirial.albedo_color = star._color
			matirial.emission_enabled = true
			matirial.emission = star._color
			matirial.emission_energy_multiplier = 2.0   # tune to taste / tie to lumanucity
			starNode.mesh.material = matirial
			var starName=str("Star_",system.Stars.find(star))
			starNode.name=starName
			#var light=OmniLight3D.new()
			#light.light_color=star._color
			#light.omni_range=star.lumanucity
			#light.light_intensity_lumens=star.lumanucity
			
			var lightName=str("StarLight_",system.Stars.find(star))
			starNode.name = "Star_%d" % star_i
			#light.name = "StarLight_%d" % star_i
			add_child(starNode)
			#add_child(light)
			var realStarNode=get_node("Star_%d" % star_i)
			#var realLightNode=get_node("StarLight_%d" % star_i)
			#light.global_position=star.starLocation+systemLocation
			starNode.global_position=star.starLocation+systemLocation
			#print(realLightNode.global_position)
