extends Node2D

@onready
var player: Car = $player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event: InputEvent):
	if event.is_action_pressed("arrow_up"):
		player.moving_north = true;
	elif event.is_action_released("arrow_up"):
		player.moving_north = false;
	if event.is_action_pressed("arrow_down"):
		player.moving_south = true;
	elif event.is_action_released("arrow_down"):
		player.moving_south = false;
	if event.is_action_pressed("arrow_left"):
		player.moving_west = true;
	elif event.is_action_released("arrow_left"):
		player.moving_west = false;
	if event.is_action_pressed("arrow_right"):
		player.moving_east = true;
	elif event.is_action_released("arrow_right"):
		player.moving_east = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
