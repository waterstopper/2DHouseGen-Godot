class_name Furniture
extends Node
onready var tile:TileMap# = get_parent().get_parent().get_node("TileMap")

var bathroomEssentials = {"diode":[-1,-1]}
var bathroom = {"shower":[2,2],"bath":[2,2],"trashcan":[1,1],
"health_kit":[2,3],"sink":[2,2],"mirror2":[2,2],"toilet":[1,1],
"washing_machine":[1,1]}

var bedroomEssentials = {"bed":[1,1,2,1]}
var bedroom = {"locker":[2,3],"bookshelf":[1,1],"cuckoo_clock":
[2,3],"commode":[1,1],"computer_table":[1,1],"grand_clock":[1,1],
"wooden_table":[1,1]}

var computer_roomEssentials = {"computer_table":[1,1]}
var computer_room = {"bookshelf":[1,1],"locker":[2,3],"trashcan":[1,1]}

var kitchen = {"trashcan":[1,1],"wooden_table_covered":[1,1],
"round_table_covered":[1,1],"kitchen_commode":[1,1],"dishwasher":[1,1],
"oven":[1,1],"hood":[2,2],"refrigerator":[1,1],"sink":[1,1],"kitchen_locker":
[2,2],"washing_machine":[1,1]}

var dining_room = {"wooden_table_covered":[1,1],"round_table_covered":[1,1],
"mirror":[2,2],"sofa":[1,1]}

var hall = {"sofa":[1,1],"small_sofa":[1,1],"blue_sofa":[1,1],"cabinet":[1,1],
"grand_clock":[1,1],"cut_table":[1,1]}

var storage = {"wooden_box":[1,1],"cabinet":[1,1],"bookshelf":[1,1]}

var communications_room = {"electrical_panel":[1,1],"tubes":[-1,-1]}

var laundryEssentials = {"ironing_desk":[1,1]}
var laundry = {"dryer":[-1,-1],"washing_machine":[1,1]}

var names:Dictionary

var onTable = {"table_lamp":[1,1],"computer":[1,1],"mug":[1,1],"bowl":[1,1],
"apple":[1,1],"canned_food":[1,1],"bottle":[1,1],"vase":[1,1],"pot":[1,1]}

var tables = {"wooden_table":[1,1,2,1],"wooden_table_covered":[1,1,2,1],
"round_table":[1,1,2,1],"round_table_covered":[1,1,2,1],"cut_table":[1,1,2,1],
"commode":[1,1,2,1],"short_wooden_table":[1,1,1,1],"kitchen_commode":[1,1,2,1],
"computer_table":[1,1,2,1]}

var chairs = {"wooden_chair":[1,1,1,2,"wooden_table","cut_table",
"wooden_table_covered"],
 "computer_chair":[1,1,1,2,"wooden_table","cut_table,","computer_table"],
"comfy_chair":[1,1,1,2,"round_table","round_table_covered"]}

var rnd = RandomNumberGenerator.new()

func _ready():
	rnd.randomize()
	CreateNamesDictionary()

func _init(foreground):
	tile = foreground
	rnd.randomize()
	CreateNamesDictionary()

#l, r, u, d.
func AddTable(_coords):
	var _indTable = rnd.randi_range()

func FillRoom(room, room_type:int):
	if(!room.isFilled):
		room.isFilled = true
		var coords = [room.l,room.r,room.u,room.d]
		var roomArr
		var roomArrEssentials = {}
		var lightArr
		match room_type:
			0:
				roomArr = bathroom
				roomArrEssentials = bathroom
				lightArr = ["diode"]
				#computer_room
			1:
				roomArr = computer_room
				roomArrEssentials = computer_roomEssentials
				lightArr = ["lamp","chandelier"]
			2:
				roomArr = bedroom
				roomArrEssentials = bedroomEssentials
				lightArr = ["lamp","chandelier"]
			3:
				roomArr = kitchen
				lightArr = ["lamp","chandelier","diode"]
			4:
				roomArr = dining_room
				lightArr = ["lamp","chandelier"]
			5:
				roomArr = hall
				lightArr = ["lamp","chandelier"]
			6:
				roomArr = storage
				lightArr = ["lamp","diode"]
			7:
				roomArr = communications_room
				lightArr = ["lamp","diode"]
			8:
				roomArr = laundry
				roomArrEssentials = laundryEssentials
				lightArr = ["lamp","diode"]
		AddLight(coords, names.get(
			lightArr[rnd.randi_range(0,lightArr.size()-1)]))
		for i in roomArrEssentials:
			AddFurniture(roomArrEssentials.get(i), names.get(i), coords)
		var keys = roomArr.keys()
		keys += keys
		keys.shuffle()
		var limit = rnd.randi_range(2, roomArr.size())
		#var counter = 0
		for i in limit:
			AddFurniture(roomArr.get(keys[i]), names.get(keys[i]), coords)
			
# l, r, u, d.
func AddFurniture(furCoords, id, coords):
	var rect = tile.tile_set.tile_get_region(id).size
	rect.x /= 12
	rect.y /= 12
	var l = rnd.randi_range(coords[0] + 1, coords[1] - rect.x)
	var d
	if(furCoords[0] == -1):
		d = coords[2] + 1
	else:
		d = coords[3] - rnd.randi_range(furCoords[0], furCoords[1])
	var busy:bool = false
	for i in rect.x:
		for j in rect.y:
			if(tile.get_cell(l + i,d + j) != -1):
				busy = true
				break
	if(furCoords[0] == -1):
		AddOnCeiling(coords, id, rect)
	elif(busy):
		FindEmptyAndSet(rect, id, coords, furCoords)
	else:
		for i in rect.x:
			for j in rect.y:
				tile.set_cell(l+i, d+j, 39, false, false, false)
		tile.set_cell(l, d, id, false, false, false)

func CreateNamesDictionary():
	var tileset:TileSet = tile.tile_set
	for i in tileset.get_tiles_ids():
		names[tileset.tile_get_name(i)] = i

func FindEmptyAndSet(rect, id, coords, furCoords):
	var flag:bool = false
	for i in range(coords[0]+1, coords[1]-rect.x):
		for j in range(coords[3] - furCoords[0], coords[3] - furCoords[1]):
			for x in rect.x:
				for y in rect.y:
					if(tile.get_cell(coords[0]+i+x,coords[3]-j+y) != -1):
						flag = true
			if flag:
				flag = false
				continue
			else:
				for x in rect.x:
					for y in rect.y:
						tile.set_cell(
							coords[0]+i+x,coords[3]-j+y, 39, false, false, false)
				tile.set_cell(coords[0]+i, coords[3]+j, id, false, false, false)
				return

func AddLight(coords, lightId):
	var isLit:bool = false
	if((((coords[1] - coords[0]) % 2 == 0 and coords[1] - coords[0] < 10) or (
		coords[1] - coords[0] < 6))
	 and tile.get_cell((coords[0]+coords[1]) / 2, coords[2]) == 0):
		tile.set_cell((coords[0]+coords[1]) / 2, coords[2] + 1,
		 lightId, false, false, false)
		isLit = true
	elif(tile.get_cell((coords[0] + (coords[0]+coords[1])/2)/2+1, coords[2]) == 0 and
			tile.get_cell((coords[1] + (coords[0]+coords[1])/2)/2, coords[2]) == 0):
		tile.set_cell((coords[0] + (coords[0]+coords[1])/2)/2+1, coords[2] + 1,
		lightId, false, false, false)
		tile.set_cell((coords[1] + (coords[0]+coords[1])/2)/2, coords[2] + 1,
		lightId, false, false, false)
		isLit = true
	if(!isLit):
		FindEmptyAndLight(coords, lightId)

func FindEmptyAndLight(coords, lightId):
	for i in range(coords[0] + 1, coords[1]):
		if(tile.get_cell(coords[0] + i, coords[2] + 1) == -1 and
			tile.get_cell(coords[0] + i, coords[2]) == 0):
			tile.set_cell(
				coords[0] + i, coords[2] + 1, lightId, false, false, false)
			return

func AddOnCeiling(coords, id, rect):
	for i in range(coords[0] + 1, coords[1]):
		var flag = true
		for j in rect.x:
			if (tile.get_cell(i + j, coords[2]) != 0 or tile.get_cell(
				i + j, coords[2] + 1) != -1):
				flag = false
		if flag:
			tile.set_cell(i, coords[2] + 1, id, false, false, false)
			return
