class_name Car
extends RigidBody2D

const NORTH_ROTATION := 0.0;
const NORTHWEST_ROTATION := 315.0;
const NORTHEAST_ROTATION := 45.0;
const SOUTH_ROTATION := 180.0;
const SOUTHWEST_ROTATION := 225.0;
const SOUTHEAST_ROTATION := 135.0;
const WEST_ROTATION := 270.0;
const EAST_ROTATION := 90.0;
const TURN_SPEED := 5.0;
const MOVE_SPEED := 300.0;
const MAX_SPEED := 500.0;
const DECEL := 100.0;

var target_rotation := 0.0;
var moving_north := false;
var moving_south := false;
var moving_west := false;
var moving_east := false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# target rotation
	var b := 0.0;

	if moving_north:
		b = NORTHWEST_ROTATION if moving_west else NORTHEAST_ROTATION if moving_east else NORTH_ROTATION;
	elif moving_south:
		b = SOUTHWEST_ROTATION if moving_west else SOUTHEAST_ROTATION if moving_east else SOUTH_ROTATION;
	elif moving_west:
		b = WEST_ROTATION;
	elif moving_east:
		b = EAST_ROTATION;
	else:
		b = target_rotation;
	
	var moving := moving_north or moving_south or moving_west or moving_east;
	
	# inertia
	if not moving:
		if [NORTH_ROTATION, SOUTH_ROTATION, WEST_ROTATION, EAST_ROTATION].find(b) == -1 and b != 0:
			b -= 45.0;

	target_rotation = b;
	
	var a := lockdeg(self.rotation_degrees)
	
	if a != b:
		# Rotate either clockwise or counterclockwise for the
		# shortest route.
		var ab: float = a - b; # counterclockwise
		var ba: float = b - a; # clockwise
		
		# for the lower delta, add 360.
		if minf(ab, ba) == ab:
			ab += 360.0;
		else:
			ba += 360.0;

		a = lockdeg(a + (-TURN_SPEED if ab < ba else +TURN_SPEED));
		a = b if a > b - TURN_SPEED and a < b + TURN_SPEED else a;
		self.rotation_degrees = a;

func lockdeg(a: float) -> float:
	a = 360.0 - (fmod(-a, 360.0)) if a < 0.0 else a
	return fmod(a, 360.0);

func _integrate_forces(state: PhysicsDirectBodyState2D):
	var vx: float = 0
	var vy: float = 0

	var moving := moving_north or moving_south or moving_west or moving_east;
	
	# moving
	if moving:
		var a_rad = self.rotation;
		vx = sin(a_rad) * MOVE_SPEED;
		vy = -cos(a_rad) * MOVE_SPEED;
		state.apply_central_force(Vector2(vx, vy))
	
	vx = state.linear_velocity.x;
	vy = state.linear_velocity.y;
	
	# deceleration
	if vx < -MOVE_SPEED and not moving_west:
		vx -= vx / DECEL;
	if vx > +MOVE_SPEED and not moving_east:
		vx -= vx / DECEL;
	if vy < -MOVE_SPEED and not moving_north:
		vy -= vy / DECEL;
	if vy > +MOVE_SPEED and not moving_south:
		vy -= vy / DECEL;

	vx = clampf(vx, -MAX_SPEED, +MAX_SPEED)
	vy = clampf(vy, -MAX_SPEED, +MAX_SPEED)
	
	state.linear_velocity = Vector2(vx, vy)
