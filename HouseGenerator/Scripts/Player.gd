class_name Player
extends KinematicBody2D
var GRAVITY = 2000
const MAXFALLSPEED = 200
const JUMPFORCE = 370
var speed
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var isJumping:bool = false
var ladder = false
var onLadder = false
onready var tile:TileMap = get_parent().get_node("TileMap")
onready var tileset:TileSet = get_parent().get_node("TileMap"
).tile_set

func _ready():
	visible= true
	speed = 100

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity.y = move_and_slide(velocity, Vector2.UP,false,4,1).y
	if(is_on_floor() and velocity.y == 0):
		isJumping = false
		if($AnimatedSprite.animation == "jump"):
			$AnimatedSprite.play("prep")
	else:
		isJumping = true

func _unhandled_input(event):
	if (event.is_action("left") or event.is_action("right")
	) and !onLadder:
		_update_direction()
	if((event.is_action("down") 
	or event.is_action("jump")) and ladder):
		velocity.x = 0
		GRAVITY = 0
		if(!is_on_floor()):
			onLadder = true
			$AnimatedSprite.play("clim")
		else:
			onLadder = false
		position.x = (int((position.x)/12))*12+6
		velocity.y = (Input.get_action_strength("down"
		)-Input.get_action_strength("jump")) * speed
	if(event.is_action_pressed("jump") and is_on_floor() and !ladder):
		$AnimatedSprite.play("jump")
		velocity.y -= JUMPFORCE
	if(event.is_action_pressed("down")):
		position.y += 1
	if(event.is_action_pressed("action")):
		var isFlipped:bool = false
		if($AnimatedSprite.flip_h):
			for x in range(-1,1):
				for y in range(-1,2):
					var til = tile.get_cell(int(position.x/12)+x,
					 int(position.y/12)+y)
					isFlipped = tile.is_cell_x_flipped(
						int(position.x/12)+x,int(position.y/12)+y)
					if(til==3):
						tile.set_cell(int(position.x/12)+x,
					 int(position.y/12)+y, 55, isFlipped, false, false)
						break
					elif(til == 55):
						tile.set_cell(int(position.x/12)+x,
						 int(position.y/12)+y, 3, isFlipped, false, false)
						break
		else:
			for x in range(0,2):
				for y in range(-1,2):
					var til = tile.get_cell(int(position.x/12)+x,
					 int(position.y/12)+y)
					isFlipped = tile.is_cell_x_flipped(
						int(position.x/12)+x,int(position.y/12)+y)
					if(til==3):
						tile.set_cell(int(position.x/12)+x,
					 int(position.y/12)+y, 55, isFlipped, false, false)
						break
					elif(til == 55):
						tile.set_cell(int(position.x/12)+x,
						 int(position.y/12)+y, 3, isFlipped, false, false)
						break

func _update_direction():
	direction.x = Input.get_action_strength("right"
	)-Input.get_action_strength("left")
	velocity.x = direction.x * speed
	if not velocity.x == 0:
		$AnimatedSprite.flip_h = velocity.x < 0
		if(!isJumping):
			$AnimatedSprite.play("walk")
	elif(!isJumping):
		$AnimatedSprite.play("idle")



func _on_Area2D_body_entered(_body):
	ladder = true


func _on_Area2D_body_exited(_body):
	ladder = false
	onLadder = false
	GRAVITY = 2000


func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation == "prep"):
		$AnimatedSprite.play("idle")
