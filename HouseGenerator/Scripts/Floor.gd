class_name Floor
extends Node2D

var numRooms:int
var rooms:Array = []
var doors:Array = []
var l:int
var r:int
var d:int
var u:int
var height:int
var width:int
var everyRoomWidth:int
var rnd = RandomNumberGenerator.new()
onready var tile:TileMap# =  get_parent().get_parent().get_node("TileMap")

# initializes floor.
func _init(var foreGround,
	var backGround,
	var posArgs:Array = [0, 0, 0, 0],
	var roomsArr:Array = [0]):

	tile = foreGround
	rnd.randomize()
	everyRoomWidth = posArgs[0]
	height = posArgs[1]
	l = posArgs[2]
	d = posArgs[3]
	u = posArgs[3] - height + 1

	for i in roomsArr.size():
		rooms.append(Room.new(foreGround, backGround, [everyRoomWidth if everyRoomWidth != 0
		else roomsArr[i], height,
		l if rooms.size() == 0 else rooms[i-1].r,
		d ]))
		add_child(rooms[i])
	r = rooms.back().r
	width = r - l + 1

# draws floor.
func DrawFloor(var ind):
	for i in rooms.size():
		rooms[i].DrawRoom(ind)
	for i in doors:
		if(tile.get_cell(i + 1, d) != -1 or tile.get_cell(i - 1, d) != -1):
			tile.set_cell(i, d - 1, 39, false,false,false)
			tile.set_cell(i, d - 2, 3, rnd.randi() % 2,false,false)



# for debugging only.
func stateDump(num:int):
	print(" Floor" + str(num) + " " + str(self))
	print("   height " + str(height))
	print("   width  " + str(r - l + 1))
	print("   left   " + str(l))
	print("   right  " + str(r))
	print("   down   " + str(d))
	print("   up     " + str(u))
	print("   rooNum " + str(rooms.size()))
	for i in rooms:
		i.stateDump()
