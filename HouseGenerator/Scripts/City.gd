class_name City
extends Node2D

var houses = []
var background:TileMap
var foreground:TileMap
var rnd:RandomNumberGenerator

# enum for house types.
enum houseType{
	ALL,
	SUBURB_ONLY,
	HIGH_HOUSE_ONLY
}

# initializes random generator,
func _init(foreGround, backGround):
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	self.background = backGround
	self.foreground = foreGround


# the only method that creates city.
func CreateCity(
	numHouses = 20,
	housetype = houseType.ALL,
	hasGround:bool = true,
	xCoord = 1,
	yCoord = 20):
	var l = xCoord
	var d = yCoord
	for i in numHouses:
		var building = Building.new(foreground, background)
		add_child(building)
		houses.append(building)
		if housetype == houseType.SUBURB_ONLY:
			building.CreateSuburbHouseCoords(l, d)
		elif housetype == houseType.HIGH_HOUSE_ONLY:
			building.CreateHighHouseCoords(l, d)
		elif rnd.randi_range(0, 199) < 100:
			building.CreateSuburbHouseCoords(l, d)
		else:
			building.CreateHighHouseCoords(l, d)
		l = building.r + rnd.randi_range(3, 6)
		if hasGround and i != numHouses - 1:
			for j in range(building.r + 1, l):
				foreground.set_cell(j, d, 56, false, false, false)
		building.DrawBuilding()

func CreateCityCoords(xCoord, yCoord):
	CreateCity(
		20,
		houseType.ALL,
		xCoord,
		yCoord)
