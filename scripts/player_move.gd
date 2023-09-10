extends CharacterBody3D

# Object References
@export var camera : Node3D

# Movement Variables
const ACCEL_SPEED = 3
const MAX_SPEED = 7
const GRAVITY = 10
const JUMP_VELOCITY = 20
#const GRAVITYDIR = Vector3.DOWN

# Input Processing variables
var _move_axis = Vector2.ZERO
var jump_pressed = false

func _process(_delta):
	var h = Input.get_axis("move_left", "move_right")
	var v = Input.get_axis("move_back", "move_forward")
	_move_axis = Vector2(h, v)
	jump_pressed = Input.is_action_pressed("jump")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	if jump_pressed && is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#direction from camera to player
	var dir3d = (global_position - camera.global_position)
	print(global_position)
	#remove the height and normalize to get a direction vector
	var dir = Vector3(dir3d.x, 0, dir3d.z).normalized()
	
	var move_horizontal_velocity = Vector3(_move_axis.x * ACCEL_SPEED, 0, _move_axis.y * ACCEL_SPEED)
	move_horizontal_velocity *= dir
	
	velocity.x = move_horizontal_velocity.x
	velocity.z = move_horizontal_velocity.z
	
	move_and_slide()
