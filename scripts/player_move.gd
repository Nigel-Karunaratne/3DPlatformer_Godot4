class_name PlayerMove
extends CharacterBody3D

# Object References
@export var camera : Node3D

var _fly = false##!!DEBUG

# Movement Variables
const ACCEL_SPEED = 2.39
const MAX_SPEED = 9
const GRAVITY = 30
const JUMP_VELOCITY = 12
const DOUBLE_JUMP_VELOCITY = 10
const ANGULAR_SPEED = TAU * 2.5

const SHORT_HOP_MULTIPLIER = 0.5

@export var friction = 0.8
@onready var friction_reset_timer = $FrictionResetTimer

var influence_velocity : Vector3 = Vector3.ZERO
var influence_velocity_decay = 0.9675
var influence_velocity_decay_grounded = 0.75
var on_accel_pad = false

var can_double_jump: bool = true

# Input Processing variables
var _move_axis = Vector3.ZERO
var jump_pressed = false
var is_currently_jumping = false
var launched_from_spring = false

var can_move = true

func _process(_delta):
	# Get directional input
	var h = Input.get_axis("move_left", "move_right")
	var v = Input.get_axis("move_back", "move_forward") 
	_move_axis = Vector3(h, 0, -v).normalized() # -Z is forward
	#jump_pressed = Input.is_action_pressed("jump")

func _unhandled_input(event):
	# Short Hopping
	if Input.is_action_just_released("jump") and is_currently_jumping and not launched_from_spring and velocity.y > 0:
		velocity.y *= SHORT_HOP_MULTIPLIER 
	
	# TODO - Remove!
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			velocity.z = -50


func _physics_process(delta):
	# Boolean check useful for stopping player movement
	if not can_move:
		return
	
	if camera != null:
		_move_axis = _move_axis.rotated(Vector3.UP, camera.rotation.y).normalized();

	##!!!! DEBUG
	#if Input.is_action_just_pressed("jump"):
	#	print("true : ", jump_pressed)

	# Jump Detection
	if Input.is_action_just_pressed("jump"):
		jump_pressed = true
		print ("should be jumping...")
	else:
		jump_pressed = false

	##!!!! DEBUG
	if Input.is_action_just_pressed("jump") and Input.is_key_pressed(KEY_F):
		_fly = !_fly
	if _fly:
		velocity.x = _move_axis.x * ACCEL_SPEED * 20
		velocity.y = ACCEL_SPEED * 20 * (1 if jump_pressed else 0)
		velocity.z = _move_axis.z * ACCEL_SPEED * 20
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	elif is_currently_jumping: # Landed back on ground
		is_currently_jumping = false
		can_double_jump = true
		print("landed. can jump again!\n")


	if is_on_floor():
		launched_from_spring = false
		if jump_pressed and !is_currently_jumping:
			velocity.y = JUMP_VELOCITY
			is_currently_jumping = true
			jump_pressed = false # so double jump doesn't trigger as well
			print("jumping!")
		# if not on_accel_pad and influence_velocity != Vector3.ZERO:
		# 	influence_velocity = Vector3.ZERO
	
	if jump_pressed and not is_on_floor() and can_double_jump:
		velocity.y = DOUBLE_JUMP_VELOCITY
		is_currently_jumping = true
		can_double_jump = false
		print("double jumping!")
	
	
	if _move_axis.length_squared() > 0:
		# Rotate the Player
		var look_direction = Vector2(-_move_axis.z, -_move_axis.x)
		var target_angle = look_direction.angle()
		
		if Vector2(velocity.x, velocity.z).length() < 0.1:
			rotation.y = target_angle # SNAP TO ANGLE
		else:
			var angular_difference = wrapf(target_angle - rotation.y, -PI, PI) # Find Shortest path to the target angle
			rotation.y += clamp(delta * ANGULAR_SPEED, 0, abs(angular_difference)) * sign(angular_difference)
		
	velocity.x += _move_axis.x * ACCEL_SPEED
	velocity.z += _move_axis.z * ACCEL_SPEED

	
	velocity.x += influence_velocity.x
	velocity.z += influence_velocity.z
	
	if is_on_floor():
		influence_velocity *= influence_velocity_decay_grounded
	else:
		influence_velocity *= influence_velocity_decay
	if influence_velocity.length() < 0.001:
		influence_velocity = Vector3.ZERO
		
	velocity.x *= friction
	velocity.z *= friction
			
	# velocity.x = velocity.x / (1 + 0.2)
	# velocity.z = velocity.z / (1 + 0.2)

	if Vector2(velocity.x, velocity.z).length() < 0.1:
		velocity.x = 0
		velocity.z = 0
	
	# print(Vector2(velocity.x, velocity.z).length())
	# print(influence_velocity)
	# print(can_double_jump, "  jump_pressed: ", jump_pressed, "  is_currently_jumping: ", is_currently_jumping)
	move_and_slide()

func launch_player_spring(new_velocity: Vector3):
	# velocity = new_velocity
	# is_currently_jumping = false
	# friction = 0.875
	# friction_reset_timer.start()
	# await friction_reset_timer.timeout
	# friction = 0.8

	influence_velocity = new_velocity
	return
