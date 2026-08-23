class_name StellarNighborhood extends Resource

var A = 0
var B = 0
var F = 0
var O = 0
var G = 0
var K = 0
var M = 0
var D = 0
var LTY=0 
var other=0
var total=0
var quadroplesPlus
var triples
var doubles
var singles
var totalSystems
var stars:Array[StellarSystem]
class Temps:
	var O_Temp
	var B_Temp
	var A_Temp
	var F_Temp
	var G_Temp
	var K_Temp
	var M_Temp
	var D_Temp
	var LTY_Temp
	var Other_Temp
	var temp_quadroplesPlus
	var temp_triples
	var temp_doubles
	var temp_singles
func classify_stellar_nieghborhood(_nieghborhood_density,_nighborhoodsize):
	B = snapped(((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.9*0.0013),0)
	O = snapped(((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.9*0.0000003),0)
	A = snapped(((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.9*0.006),0)
	F = snapped(((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.9*0.03),0)
	G = snapped(((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.9*0.076),0)
	K = snapped(((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.9*0.121),0)
	M = snapped(((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.9*0.7645),0)
	D = snapped(((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.9*0.09),0)
	LTY= snapped((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))/2.5,0)
	other=floor((_nieghborhood_density*((4.0/3.0)*PI*_nighborhoodsize**3.0))*0.01)
	total=O+B+A+F+G+K+M+D+LTY+other
	var temps= Temps.new()
	temps.O_Temp=O
	temps.B_Temp=B
	temps.A_Temp=A
	temps.F_Temp=F
	temps.G_Temp=G
	temps.K_Temp=K
	temps.M_Temp=M
	temps.D_Temp=D
	temps.LTY_Temp=LTY
	temps.Other_Temp=other
	quadroplesPlus=round((total/1.58)*0.03)
	triples=round((total/1.58)*0.08)
	doubles=round((total/1.58)*0.33)
	singles=total-((doubles*2)+(triples*3)+(quadroplesPlus*4))
	temps.temp_quadroplesPlus=quadroplesPlus
	temps.temp_triples=triples
	temps.temp_doubles=doubles
	temps.temp_singles=singles
	totalSystems=quadroplesPlus+triples+doubles+singles
	for system in range(totalSystems):
		var system_type=chooseSystemType(temps)
		var starTypes:Array[String]
		match system_type:
			"SINGLE":
				var type= randomStarType(temps)
				starTypes.append(type)
				removeStarFromTemp(type,temps)
				temps.temp_singles-=1
			"BINARY":
				var type= randomStarType(temps)
				var type2= randomStarType(temps)
				starTypes.append(type)
				starTypes.append(type2)
				removeStarFromTemp(type,temps)
				removeStarFromTemp(type2,temps)
				temps.temp_doubles-=1
			"TRIPLE":
				var type= randomStarType(temps)
				removeStarFromTemp(type,temps)
				starTypes.append(type)
				var type2= randomStarType(temps)
				removeStarFromTemp(type2,temps)
				starTypes.append(type2)
				var type3= randomStarType(temps)
				starTypes.append(type3)
				removeStarFromTemp(type3,temps)
				temps.temp_triples-=1
			"QUADROPLE_PLUS":
				var type= randomStarType(temps)
				removeStarFromTemp(type,temps)
				var type2= randomStarType(temps)
				removeStarFromTemp(type2,temps)
				var type3= randomStarType(temps)
				removeStarFromTemp(type3,temps)
				var type4= randomStarType(temps)
				removeStarFromTemp(type4,temps)
				starTypes.append(type)
				starTypes.append(type2)
				starTypes.append(type3)
				starTypes.append(type4)
				temps.temp_quadroplesPlus-=1
		var cursystem=StellarSystem.new()
		cursystem.makeStellarSystem(system_type,starTypes)
	return self
func randomStarType(temps):
	var keys = Star.starType.keys()
	var type = keys[randi_range(0, keys.size() - 1)]
	var type_num = Star.starType[type]

	while true:
		
		match type:
			"O":
				if temps.O_Temp>0:
					break
			"B":
				if temps.B_Temp>0:
					break
			"A":
				if temps.A_Temp>0:
					break
			"F":
				if temps.F_Temp>0:
					break
			"G":
				if temps.G_Temp>0:
					break
			"K":
				if temps.K_Temp>0:
					break
			"M":
				if temps.M_Temp>0:
					break
			"D":
				if temps.D_Temp>0:
					break
			"LTY":
				if temps.LTY_Temp>0:
					break
			"OTHER":
				if temps.Other_Temp>0:
					break
		type = keys[randi_range(0, keys.size() - 1)]
	print(type)
	return type
func removeStarFromTemp(type,temps):
	match type:# I thought how to not repeat this but i came with nothing
		"O":#I need to fix
			temps.O_Temp-=1
		"B":
			temps.B_Temp-=1
		"A":
			temps.A_Temp-=1
		"F":
			temps.F_Temp-=1
		"G":
			temps.G_Temp-=1
		"K":
			temps.K_Temp-=1
		"M":
			temps.M_Temp-=1
		"D":
			temps.D_Temp-=1
		"LTY":
			temps.LTY_Temp-=1
		"OTHER":
			temps.Other_Temp-=1
func chooseSystemType(temps):
	var keys = StellarSystem.SystemType.keys()
	var type = keys[randi_range(0, keys.size() - 1)]
	while true:
		match type:
			"SINGLE":
					if temps.temp_singles>0:
						break
			"BINARY":
				if temps.temp_doubles>0:
						break
			"TRIPLE":
				if temps.temp_triples>0:
						break
			"QUADROPLE_PLUS":
				if temps.temp_quadroplesPlus>0:
						break
		type = keys[randi_range(0, keys.size() - 1)]
	return type
