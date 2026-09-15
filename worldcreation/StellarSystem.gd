class_name StellarSystem extends Resource

enum SystemType {
	SINGLE,
	BINARY,
	TRIPLE,
	QUADROPLE_PLUS
}

# [min_mass, max_mass, alpha] — alpha controls how top-heavy-rare the tail is
var ClassToMass = {
	"O": [16.0, 291.0, 2.35],
	"B": [2.1, 16.0, 2.35],
	"A": [1.4, 2.1, 2.35],
	"F": [1.04, 1.4, 2.35],
	"G": [0.8, 1.4, 2.35],
	"K": [0.45, 0.8, 2.35],
	"M": [0.08, 0.45, 1.3],
	"D": [0.5, 0.7, 1.3],
	"LTY": [0.012415, 0.0764, 1.3],
	"OTHER": [30, 2000, 5],
}
var orbitalStablePoint=50#idk what it should actualy be
var SType: SystemType
var Planets: Array[Planet]
var Stars: Array[Star]
var Location : Vector3
var RelativeLocation : Array[float]=[0,0,0]#phi(longetude) theta(lattatude) radius(magnatude)(altetude)
var _rng := RandomNumberGenerator.new()

func _init():
	_rng.randomize()
	
func makeHomeStellarSystem(Type, starMasses: Array[float]):
	
	for star in starMasses:
		#var starType
		#for mass in ClassToMass.values():
			#if Global.is_in_range(mass[0],mass[1],star):
				#starType=ClassToMass.find_key(mass)
		Location=Vector3.ZERO
		var _star=Star.new()
		_star.makeStar(star)
		var distFromGravCenter=(starMasses.size()-1)*orbitalStablePoint
		var starOfset=360/starMasses.size()
		_star.starLocation=Vector3((Vector2.from_angle(deg_to_rad(starOfset*star))*distFromGravCenter).x,\
		(Vector2.from_angle(deg_to_rad(starOfset*star))*distFromGravCenter).y,0)
		Stars.append(_star)
	return self
func makeStellarSystem(Type, starTypes: Array[String],Neiborhood_size:float):
	var r=randf_range(1,Neiborhood_size)
	var theta= randf()*(randi()%360)
	var pheta =randf()*(randi()%360)
	RelativeLocation[0]=pheta
	RelativeLocation[1]=theta
	RelativeLocation[2]=r
	#convert altatude lattatude and longetude to x,y,z
	var lat=deg_to_rad(theta)
	var lon=deg_to_rad(pheta)
	
	Location.x=r*cos(lat)*cos(lon)
	Location.y=r*cos(lat)*sin(lon)
	Location.z=r*sin(lat)
	SType = SystemType.get(Type) 
	var StarNum = SystemType.get(Type) + 1
	if not StarNum == starTypes.size():
		printerr("System type and star type.size aren't equal FIX IT!!!!1!")
	var starOfset=360/StarNum#i know that this is only one type of star system but.. idk how it make an 8 shaped one
	var distFromGravCenter=(StarNum-1)*orbitalStablePoint
	for star in range(StarNum):
		var type = starTypes.pop_front()
		var _star = Star.new()
		
		_star.starLocation=Vector3((Vector2.from_angle(deg_to_rad(starOfset*star))*distFromGravCenter).x,\
		(Vector2.from_angle(deg_to_rad(starOfset*star))*distFromGravCenter).y,0)
		var range_and_alpha = ClassToMass[type]
		var mass = sample_mass(range_and_alpha[0], range_and_alpha[1], range_and_alpha[2], _rng)
		
		_star.makeStar(mass)
		Stars.append(_star)
	return self
static func sample_mass(mass_min: float, mass_max: float, alpha: float, rng: RandomNumberGenerator) -> float:
	var u = rng.randf()
	var e = 1.0 - alpha
	var low = pow(mass_min, e)
	var high = pow(mass_max, e)
	var val = low + u * (high - low)
	return pow(val, 1.0 / e)
