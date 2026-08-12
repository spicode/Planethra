extends Resource
class_name Star
enum starType{
O,
B,
A,
F,
G,
K,
M,
D,
L,T,Y,
OTHER
}
var maxAge
var currentAge
var mass
var radius
var lumanucity
var density
var temprature
var _color
var habitableZone:Array[float]
var type

func makeStar(_mass,_currentAge=1.00) -> Star:
	mass = _mass
	radius=  mass^0.8 if mass < 1 else mass^0.57
	lumanucity = 0.23*mass^2.3 if mass<0.43 else (mass^4 if mass<2 else mass^3.5)
	density = mass/radius^3
	temprature =((lumanucity/radius^2)^0.25)*5776
	_color= Global.Kelvin2Rgb(temprature)
	habitableZone[0]=snapped(sqrt(lumanucity/1.1),0.001)
	habitableZone[1]= snapped(sqrt(lumanucity/0.53),0.001)
	return self
