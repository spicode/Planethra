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

var SType: SystemType
var Planets: Array[Planet]
var Stars: Array[Star]

var _rng := RandomNumberGenerator.new()

func _init():
	_rng.randomize()

func makeStellarSystem(Type, starTypes: Array[String]):
	SType = SystemType.get(Type) 
	var StarNum = SystemType.get(Type) + 1
	if not StarNum == starTypes.size():
		printerr("System type and star type.size aren't equal FIX IT!!!!1!")

	for star in range(StarNum):
		var type = starTypes.pop_front()
		var _star = Star.new()

		var range_and_alpha = ClassToMass[type]
		var mass = sample_mass(range_and_alpha[0], range_and_alpha[1], range_and_alpha[2], _rng)

		_star.makeStar(mass)
		Stars.append(_star)

static func sample_mass(mass_min: float, mass_max: float, alpha: float, rng: RandomNumberGenerator) -> float:
	var u = rng.randf()
	var e = 1.0 - alpha
	var low = pow(mass_min, e)
	var high = pow(mass_max, e)
	var val = low + u * (high - low)
	return pow(val, 1.0 / e)
