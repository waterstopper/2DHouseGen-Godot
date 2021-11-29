extends Node2D
onready var tileMap = get_node("TileMap")
onready var tileMap2 = get_node("TileMap2")
onready var b = preload("res://Building.tscn")
onready var player = preload("res://Player.tscn").instance()
var children = [0]
var _previousPosition: Vector2 = Vector2(0, 0)
var _moveCamera: bool = false

# Press SPACE after launch to generate new suburb house
# Move with mouse or WASD
# scroll wheel to zoom

func _ready():
	var city = City.new(tileMap, tileMap2)
	city.CreateCity(20, City.houseType.SUBURB_ONLY)
	#add_child(player)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			_previousPosition = event.position
			_moveCamera = true
		else:
			_moveCamera = false
	elif event is InputEventMouseMotion and _moveCamera:
		$Camera2D.position += (_previousPosition - event.position)
		_previousPosition = event.position
	elif event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP:
		$Camera2D.zoom /= 1.1
	elif event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN:
		$Camera2D.zoom *= 1.1
	elif(event is InputEventScreenTouch):
		tileMap.clear()
		tileMap2.clear()
		var buld = b.instance()
		add_child(buld)
		buld.CreateSuburbHouse()
		buld.DrawBuilding()
		children[0] = buld
	elif event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			tileMap.clear()
			tileMap2.clear()
			var buld = Building.new(tileMap, tileMap2)
			var city = City.new(tileMap, tileMap2)
			add_child(buld)
			buld.CreateSuburbHouse()
			buld.DrawBuilding()
			children[0] = buld
		if event.pressed and event.scancode == KEY_A:
			$Camera2D.position.x -= 5
		if event.pressed and event.scancode == KEY_D:
			$Camera2D.position.x += 5
		if event.pressed and event.scancode == KEY_W:
			$Camera2D.position.y -= 5
		if event.pressed and event.scancode == KEY_S:
			$Camera2D.position.y += 5
		if event.pressed and event.scancode == KEY_Q:
			$Camera2D.zoom *= 1.1
		if event.pressed and event.scancode == KEY_E:
			$Camera2D.zoom /= 1.1
