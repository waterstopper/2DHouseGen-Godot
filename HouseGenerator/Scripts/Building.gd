class_name Building
extends Node2D

var numFloors:int
var floors:Array = []
var windows:Array = []
var emptyXY:Array = []
var rnd : RandomNumberGenerator
var l:int
var r:int
var d:int
var u:int
var basement:Room
onready var tile:TileMap
onready var tile2:TileMap
var furniture
var makeWindows:bool = true
var addFurniture:bool = true

# initializing random generator and adding furnitute instance.
func _ready():
	#furniture = Furniture.new(tile)
	#add_child(furniture)
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	l = 1
	d = 20

# adding tilemaps references to class.
func _init(foreground, background):
	tile = foreground
	tile2 = background
	furniture = Furniture.new(tile)
	add_child(furniture)
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	l = 1
	d = 20


# base method, creates high house.
func CreateHighHouse(
	floorsNum:int = rnd.randi_range(10, 12),
	roomsleft:int = rnd.randi_range(0, 3),
	roomsright:int = rnd.randi_range(0, 3),
	numladders:int = rnd.randi_range(1, 2),
	roofEnter:bool = rnd.randi_range(0, 1),
	roomsNum = rnd.randi_range(2, 4),
	addFurnitureParam = true,
	createDoors = true,
	createWindows = true,
	_createBasement = true if rnd.randi_range(0, 1) == 1 else false,
	xCoord = 1,
	yCoord = 20):

	l = xCoord
	d = yCoord
	addFurniture = addFurnitureParam
	makeWindows = createWindows
	numFloors = floorsNum
	var laddersIndex = []
	var height:int = rnd.randi_range(5, 6)
	if(roomsright == roomsleft and roomsright == 0):
		roomsright = rnd.randi_range(1, 3)
		roomsleft = rnd.randi_range(1, 3)
	var numRooms = numladders + roomsleft + roomsright
	# one ladder between.
	if(numladders == 1):
		laddersIndex.append(roomsleft)
	# two ladders that are being placed in one of three variants.
	elif numladders > 1:
		var laddersType = rnd.randi_range(0, 2)
		if(laddersType == 0):
			laddersIndex.append(0)
			laddersIndex.append(roomsleft+1)
		elif laddersType == 1:
			laddersIndex.append(roomsleft)
			laddersIndex.append(roomsleft + roomsright + 1)
		else:
			laddersIndex.append(0)
			laddersIndex.append(roomsleft + roomsright + 1)
	var roomsArr = []
	var width = 0
	for i in numRooms:
		roomsArr.append(rnd.randi_range(6, 9))
		width += roomsArr[i]
	floors.append(Floor.new(tile, tile2, [0, height, l, d], roomsArr))
	r = floors[0].r
	add_child(floors[0])
	for i in laddersIndex:
		# Creating platforms.
		for j in range(floorsNum - (1 if !roofEnter else 0)):
			for k in range(floors[0].rooms[i].l + 1, floors[0].rooms[i].r):
				tile2.set_cell(
					k, floors[0].d -(j+1)*(height-1), 6, false, false, false)
		# Adding stairs.
		floors[0].rooms[i].CreateStairsOrLadder(-1, floors[0].rooms[i].l + 1,
		floors[0].d - floors[0].height * floorsNum + (
			floorsNum if roofEnter else floorsNum + 2), floors[0].rooms[i].r)
		# No furni in stairs.
		floors[0].rooms[i].isFilled = true
		floors[0].rooms[i].u = floors[0].d - floors[0].height * floorsNum + (
			floorsNum - floors[0].height if roofEnter else floorsNum)
		floors[0].rooms[i].height = d-floors[0].rooms[i].u#(
		#	floors[0].rooms[i].d - floors[0].rooms[i].u) + 1
	for iter in range(floorsNum - 1):
		roomsArr.clear()
		laddersIndex.clear()
		width = 0
		# looking for left bound of roomsArr
		var isLeft = true
		var leftSide = 0
		for i in floors[0].rooms:
			if isLeft and !i.isFilled:
				leftSide = i.l
				isLeft = false
			elif(i.isFilled and !isLeft):
				CreateHighHouseRooms(leftSide, i.l, roomsArr)
				roomsArr.append(i.width)
				laddersIndex.append(roomsArr.size() - 1)
				isLeft = true
			elif(i.isFilled):
				roomsArr.append(i.width)
				laddersIndex.append(roomsArr.size() - 1)
		if(!isLeft):
			CreateHighHouseRooms(leftSide, floors[0].rooms.back().r, roomsArr)
		floors.append(Floor.new(tile, tile2, [0, height, l, floors[iter].u], roomsArr))
		add_child(floors[iter+1])
		for i in laddersIndex:
			# indexes may change
			floors[iter+1].rooms[i].drawn = true
			floors[iter+1].rooms[i].isFilled = true
	if createDoors:
		_CreateDoors()
	if _createBasement:
		_createBasement()

# base method, creates suburb house.
func CreateSuburbHouse(
	floorsNum = rnd.randi_range(2, 5),
	roomsNum = rnd.randi_range(2, 4),
	addFurnitureParam = true,
	createDoors = true,
	createWindows = true,
	_createBasement = true if rnd.randi_range(0, 1) == 1 else false,
	xCoord = 1,
	yCoord = 20):

	l = xCoord
	d = yCoord
	addFurniture = addFurnitureParam
	makeWindows = createWindows
	numFloors = floorsNum
	for i in numFloors:
		#DrawBuilding()
		var roomsArr = []
		var widthNow = 0
		for j in roomsNum: # creates array of width for rooms
			roomsArr.append(rnd.randi_range(6, 9))
			widthNow += roomsArr.back() - 1
		widthNow += 1
		if(i > 0):
			while(widthNow > floors.back().width):
				widthNow -= (roomsArr.pop_back() - 1)
		if(roomsArr.size() == 0):
			roomsArr.append(floors[i-1].rooms[0].width)
			widthNow = roomsArr.back()
		var heightVar = rnd.randi() % 2 + 5
		#rnd.randomize()
		floors.append(Floor.new(tile, tile2,
		 [0,							# filled Room Width
		 heightVar,						# height
		 l if (floors.size() == 0) else # l coord
		 floors[i-1].l if floors.back().width == widthNow
		 else
		 rnd.randi_range(floors[i-1].l, floors[i-1].r - widthNow + 1),
		 floors.back().d-floors.back().height+1 if floors.size()
		 != 0 else d],
		 roomsArr))						# array of rooms widths
		add_child(floors[i])
	r = floors[0].r

	_MergeRooms()
	if createDoors:
		_CreateDoors()
	for i in range(numFloors - 1, 0, -1):
		var arr = _FindNCellsBetweenFloors(i)
		if(arr != null and arr[2] - arr[1] > 3 and !arr[0].merged):
			arr[1] = rnd.randi_range(arr[1], arr[2] - 4)
			arr[2] = arr[1] + 4
		if(arr != null and !arr[0].hasStairs):
			match arr[3]:
				0:
					arr[0].CreateStairsOrLadder(
						-1, arr[2], floors[i].d, arr[1] - 1)
				1:
					arr[0].CreateStairsOrLadder(
						1, arr[1], floors[i].d, arr[2] + 1)
				2:
					var waht = rnd.randi() % 2
					if(waht == 0):
						arr[0].CreateStairsOrLadder(
							-1, arr[2], floors[i].d, arr[1] - 1)
					else:
						arr[0].CreateStairsOrLadder(
							1, arr[1], floors[i].d, arr[2] + 1)
				_:
					push_error("_FindNCellsBetweenFloors doesn't work!")
		for j in range(arr[2] - arr[1] + 1):
				# can't draw because highest room redraws it.
				emptyXY.append([arr[1]+j, floors[i].d])
	if _createBasement:
		_createBasement()

# creates high house with coordinates only.
func CreateHighHouseCoords(xCoord, yCoord):
	CreateHighHouse(
		rnd.randi_range(10, 12),
		rnd.randi_range(0, 3),
		rnd.randi_range(0, 3),
		rnd.randi_range(1, 2),
		rnd.randi_range(0, 1),
		rnd.randi_range(2, 4),
		true,
		true,
		true,
		rnd.randi_range(0, 1),
		xCoord,
		yCoord)

# creates suburb house with coordinates only.
func CreateSuburbHouseCoords(xCoord, yCoord):
	CreateSuburbHouse(
		rnd.randi_range(2, 5),
		rnd.randi_range(2, 4),
		true,
		true,
		true,
		rnd.randi_range(0, 1),
		xCoord,
		yCoord)

# creating rooms in a way so that every floor looks different form previous.
func CreateHighHouseRooms(lLocal:int, rLocal:int, roomsArr:Array):
	while true:
		if(rLocal - lLocal < 10):
			roomsArr.append(rLocal - lLocal + 1)
			return
		if(rLocal - lLocal < 13):
			roomsArr.append(rnd.randi_range(6, rLocal - lLocal - 6))
			roomsArr.append(rLocal - lLocal - roomsArr.back() + 2)
			return
		else:
			roomsArr.append(rnd.randi_range(6, 9))
			lLocal += roomsArr.back() - 1

# creating basement.
func _createBasement():
	var width = rnd.randi_range(6, 10)
	if width > floors[0].r - floors[0].l + 1:
		width = floors[0].r - floors[0].l + 1
	var leftBasement = rnd.randi_range(l, r - width + 1)
	var ladderPlace = rnd.randi_range(leftBasement+1, leftBasement + width - 3)
	for i in floors[0].rooms:
		if ladderPlace == i.r:
			ladderPlace += 1
			break
	basement = Room.new(tile, tile2,
		[width, floors[0].height, leftBasement, d + floors[0].height - 1])
	basement.CreateStairsOrLadder(1, ladderPlace,d,ladderPlace+2)
	floors[0].add_child(basement)

# used for creating stairs. Looks for N cells between floors where
# a ladder might be put.
func _FindNCellsBetweenFloors(ind, n:int = 4):
	# find merged first
	for i in floors[ind].rooms:
		if(i.merged and i.u == floors[ind].u):
			return [i, i.l + 1, i.r - 1, 2]
	#rnd.randomize()
	var reversed = false
	if(rnd.randi()%2==0):
		floors[ind].rooms.invert()
		reversed = true
	for i in floors[ind].rooms:
		for j in floors[ind-1].rooms:
			if(min(i.r, j.r ) - max(i.l, j.l) >= n + 1 and (
				(i.l >= j.l and i.l < j.r) or (i.r > j.l and i.r <= j.r) or (
				 j.l >= i.l and j.l < i.r) or (j.r > i.l and j.r <= i.r) )):
				if(reversed):
					floors[ind].rooms.invert()
				return [j, max(i.l, j.l) + 1,  min(i.r, j.r) - 1, (
					0 if i.l == j.l else (1 if i.r == j.r else 2)
				)]
			elif(floors[ind].rooms.back() == i and
			floors[ind-1].rooms.back() == j):
				if(reversed):
					floors[ind].rooms.invert()
				return _FindNCellsBetweenFloors(ind, n-1)

# draws all house parts.
func DrawBuilding():
	for i in floors.size():
		floors[i].DrawFloor(i%3)
	for i in emptyXY:
		tile2.set_cell(i[0], i[1], 6, false, false, false)
		tile.set_cell(i[0], i[1], 6, false, false, false)
	_DrawStairs()
	# In that order platforms won't connect with windows probably =P (spoiler: they will)
	if makeWindows:
		_CreateWindows()
		_DrawWindows()
	if addFurniture:
		for i in floors:
			for j in i.rooms:
				if(!j.isFilled):
					furniture.FillRoom(j, rnd.randi_range(0,8))
	if(basement != null):
		basement.DrawRoom(0)
		for i in range(l,r):
			if(tile2.get_cell(i,d) != -1):
				tile.set_cell(i, d, 6, false, false, false)

# draws windows.
func _DrawWindows():
	var whatGlass = 1
	if rnd.randi() % 2 == 0:
		whatGlass = 2
	for i in windows.size()/2:
		for j in range(min(windows[i*2][1],windows[i*2+1][1]),
		max(windows[i*2][1],windows[i*2+1][1])+1):
			tile.set_cell(windows[i*2][0], j, whatGlass, false, false, false)

# draws stairs.
func _DrawStairs():
	for i in floors:
		for j in i.rooms:
			if(!j.stairsDrawn):
				j.DrawStairs()
	if basement != null:
		basement.DrawStairs()

# merges 2 rooms in 1 or 4 in 1.
func _MergeRooms():
	if(floors.size() < 2):
		return
	# Merge4 to 1
	var i = 0; var j = 0
	while(i < floors[0].rooms.size()-1 and j < floors[1].rooms.size()-1):
		if (floors[0].rooms[i].l == floors[1].rooms[j].l
		 and floors[0].rooms[i].width == floors[1].rooms[j].width
		 and floors[0].rooms[i+1].width == floors[1].rooms[j+1].width):

			floors[0].rooms[i].u = floors[1].rooms[j].u
			floors[0].rooms[i].r = floors[0].rooms[i+1].r
			floors[0].rooms[i].width = (floors[0].rooms[i].r
			 - floors[0].rooms[i].l) + 1

			floors[0].rooms[i+1].merged = true
			floors[0].rooms.remove(i+1)
			floors[1].rooms[j] = floors[0].rooms[i]
			floors[1].rooms.remove(j+1)
			i += 1; j += 1; continue
		if(floors[0].rooms[i].l < floors[1].rooms[j].l):
			i += 1
		elif(floors[0].rooms[i].l > floors[1].rooms[j].l):
			j += 1
		else:
			i += 1; j += 1
	for k in floors.size()-1:
		i = 0; j = 0
		while(i < floors[k].rooms.size() and j < floors[k+1].rooms.size()):
			if (floors[k].rooms[i].l == floors[k+1].rooms[j].l
			and floors[k].rooms[i].width == floors[k+1].rooms[j].width
			 and !floors[k].rooms[i].merged
			 and !floors[k+1].rooms[j].merged):

				floors[k].rooms[i].height += floors[k+1].rooms[j].height-1
				floors[k].rooms[i].u = floors[k+1].rooms[j].u
				floors[k].rooms[i].merged = true
				floors[k+1].rooms[j] = floors[k].rooms[i]
			if(floors[k].rooms[i].l < floors[k+1].rooms[j].l):
				i += 1
			elif(floors[k].rooms[i].l > floors[k+1].rooms[j].l):
				j += 1
			else:
				i += 1; j += 1

# creates doors.
func _CreateDoors():
	for i in floors[0].rooms.size():
		floors[0].doors.append(floors[0].rooms[i].l)
		if(i > 0 and floors[0].rooms[i-1].height < 7):
			floors[0].doors.append(floors[0].rooms[i].l)
	floors[0].doors.append(
		floors[0].rooms[floors[0].rooms.size()-1].l
		+ floors[0].rooms[floors[0].rooms.size()-1].width - 1)
	for i in range(1, floors.size()):
		for j in range(1, floors[i].rooms.size()):
			floors[i].doors.append(floors[i].rooms[j].l)
			if(i > 0 and !floors[i].rooms[j-1].merged):
				floors[i].doors.append(floors[i].rooms[j].l)

# creates windows.
func _CreateWindows():
	var createLeft:bool = true
	var createRight:bool = true
	if(floors[0].rooms[0].height > 6 and !floors[0].rooms[0].isFilled):
		for _i in range(2):
			windows.append([floors[0].rooms[0].l,
			 rnd.randi_range(floors[0].rooms[0].u+1,
			 floors[0].rooms[0].d-4)])
	elif(floors[0].rooms[0].isFilled):
		createLeft = false
		var base = d - floors[0].height - 3
		var threeOrTwo = rnd.randi_range(1, 2)
		for _i in range(numFloors-1):
			windows.append([floors[0].rooms[0].l, base + 1])
			windows.append([floors[0].rooms[0].l, base + threeOrTwo + 1])
			base -= (floors[0].height - 1)
	if(floors[0].rooms.back().height > 6 and !floors[0].rooms.back().isFilled):
		for _i in range(2):
			windows.append([floors[0].rooms.back().r,
			rnd.randi_range(floors[0].rooms.back().u+1,
			floors[0].rooms.back().d-4)])
	elif(floors[0].rooms.back().isFilled):
		createRight = false
		var base = d - floors[0].height - 3
		var threeOrTwo = rnd.randi_range(1, 2)
		for _i in range(numFloors-1):
			windows.append([floors[0].rooms.back().r, base + 1])
			windows.append([floors[0].rooms.back().r, base + threeOrTwo + 1])
			base -= (floors[0].height - 1)
	var downLimit:int = 0
	if(createLeft):
		for j in range(1, floors.size()):
			# solving an issue of windows going through walls.
			downLimit = floors[j].rooms[0].d - 1
			for k in range(floors[j].rooms[0].d - 1, floors[j].rooms[0].u, -1):
				# don't have cells yet!
				if(tile.get_cell(floors[j].rooms[0].l + 1, k) != -1 or (
					tile.get_cell(floors[j].rooms[0].l - 1, k) != -1)):
						downLimit = k
						break
			if(j != 1 or !floors[j].rooms[0].merged):
				for _i in range(2):
					windows.append([floors[j].rooms[0].l,
					 rnd.randi_range(floors[j].rooms[0].u + 1,
					 downLimit - 1)])
	if(createRight):
		for j in range(1, floors.size()):
			# solving an issue of windows going through walls.
			downLimit = floors[j].rooms.back().d - 1
			for k in range(floors[j].rooms.back().d - 1,
			 floors[j].rooms.back().u, -1):
				if(tile.get_cell(floors[j].rooms.back().r + 1, k) != -1 or (
					tile.get_cell(floors[j].rooms.back().r - 1, k) != -1)):
						downLimit = k
						break
			if(j != 1 or !floors[j].rooms.back().merged):
				for _i in range(2):
					windows.append([floors[j].rooms.back().r,
					 rnd.randi_range(floors[j].rooms.back().u + 1,
					 downLimit - 1)])



# for debugging only.
func stateDump():
	print("Building" + str(self))
	for i in windows:
		print(str(i[0])+ " "+str(i[1]))
	print("  left   " + str(l))
	print("  right  " + str(r))
	print("  down   " + str(d))
	print("  up     " + str(u))
	for i in floors.size():
		floors[i].stateDump(i)
