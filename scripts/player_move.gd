class_name PlayerMove
extends CharacterBody3D

# Object References
@export var camera : Node3D

# Movement Variables
const ACCEL_SPEED = 2
const MAX_SPEED = 9
const GRAVITY = 30
const JUMP_VELOCITY = 12
const ANGULAR_SPEED = TAU * 2

const SHORT_HOP_MULTIPLIER = 0.5

@export var friction = 0.8

# Input Processing variables
var _move_axis = Vector3.ZERO
var jump_pressed = false
var is_currently_jumping = false

func _process(_delta):
	var h = Input.get_axis("move_left", "move_right")
	var v = Input.get_axis("move_back", "move_forward") 
	_move_axis = Vector3(h, 0, -v).normalized() # -Z is forward
	jump_pressed = Input.is_action_just_pressed("jump")


func _unhandled_input(event):
	# Short Hopping
	if Input.is_action_just_released("jump") and is_currently_jumping and velocity.y > 0:
		velocity.y *= SHORT_HOP_MULTIPLIER 
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			velocity.z = -50


func _physics_process(delta):
	if camera != null:
		_move_axis = _move_axis.rotated(Vector3.UP, camera.rotation.y).normalized();

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	elif is_currently_jumping: # Landed back on ground
		is_currently_jumping = false
	
	if jump_pressed && is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_currently_jumping = true

	velocity.x += _move_axis.x * ACCEL_SPEED
	velocity.z += _move_axis.z * ACCEL_SPEED
	
	velocity.x *= friction
	velocity.z *= friction

	if _move_axis.length_squared() > 0:
		# Rotate the Player
		var look_direction = Vector2(-velocity.z, -velocity.x)
		var target_angle = look_direction.angle()
		rotation.y = target_angle	
		pass
	
	if Vector2(velocity.x, velocity.z).length() < 0.1:
		velocity.x = 0
		velocity.z = 0
	
	print(Vector2(velocity.x, velocity.z).length())
	move_and_slide()

func launch_player_spring(new_velocity: Vector3):
	velocity = new_velocity
	is_currently_jumping = false
	return
