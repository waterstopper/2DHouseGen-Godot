class_name Room
extends Node2D

var width:int
var height:int
var merged:bool = false
var drawn:bool = false
var stairsDrawn:bool = false
var hasStairs:bool = false
var isFilled = false
var ladderXY:Array = []
var stairsXY:Array = []
var room_type
var l:int
var r:int
var u:int
var d:int
onready var tile:TileMap
onready var tile2:TileMap

# initializing room coordinates.
func _init(foreGround, backGround, var posArgs:Array = [0, 0, 0, 0]):
	width = posArgs[0]; height = posArgs[1]
	l = posArgs[2]; d = posArgs[3]
	r = l + width - 1; u = d - height + 1
	tile = foreGround
	tile2 = backGround

# delegate creation to below recursive method.
func CreateStairsOrLadder(xAdd:int, startX:int, startY:int, xLim:int):
	hasStairs = true
	match int(abs(startX - xLim)):
		2:
			var h = startY
			while(d > h):
				ladderXY.append([startX, h])
				h += 1
			return
		3:
			stairsXY.append([startX, startY])
			return _CreateStairsOrLadderSub(xAdd, startX, startY + 1, xLim)
		4:
			stairsXY.append([startX, startY])
			return _CreateStairsOrLadderSub(
				xAdd, startX, startY + 1, l if xAdd == -1 else r)
		_:
			return _CreateStairsOrLadderSub(
				xAdd, startX, startY, l if xAdd == -1 else r)

# create stairs or ladder step by step in recursion.
func _CreateStairsOrLadderSub(xAdd:int, startX:int, startY:int, xLim:int):
	var h = startY; var w = startX + xAdd
	while(d > h and abs(w - xLim) > 0):
		stairsXY.append([w, h])
		stairsXY.append([w-xAdd, h])
		w += xAdd; h += 1
	if(h < d):
		return _CreateStairsOrLadderSub(
			-xAdd, w - xAdd, h - 1, r if xAdd == -1 else l)

# draws room.
func DrawRoom(var _ind):
	if(!drawn):
		for i in width:
			tile.set_cell(l+i, d, 0, false, false, false)
			tile.set_cell(l+i, u, 0, false, false, false)
		for i in height:
			tile.set_cell(l, d-i, 0, false, false, false)
			tile.set_cell(r, d-i, 0, false, false, false)
		drawn = true

# draws stairs.
func DrawStairs():
	for i in stairsXY.size():
		tile.set_cell(stairsXY[i][0], stairsXY[i][1], 4, false, false, false)
	for i in ladderXY.size():
		tile2.set_cell(ladderXY[i][0], ladderXY[i][1], 5, false, false, false)
	tile.update_bitmask_region(Vector2(l, d), Vector2(r, u))
	stairsDrawn = true



# for debugging only.
func stateDump():
	print("  Room " + str(self))
	print("    height " + str(height))
	print("    width  " + str(r - l + 1))
	print("    left   " + str(l))
	print("    right  " + str(r))
	print("    down   " + str(d))
	print("    up     " + str(u))
	print("    merged " + str(merged))
