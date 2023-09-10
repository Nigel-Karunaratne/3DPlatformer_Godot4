extends CharacterBody3D

# Object References
@export var camera : Node3D

# Movement Variables
const ACCEL_SPEED = 1
const MAX_SPEED = 9
const GRAVITY = 26
const JUMP_VELOCITY = 10
const ANGULAR_SPEED = TAU * 2
#const GRAVITYDIR = Vector3.DOWN

var friction = 0.7

# Input Processing variables
var _move_axis = Vector2.ZERO
var jump_pressed = false

func _process(_delta):
	var h = Input.get_axis("move_left", "move_right")
	var v = Input.get_axis("move_back", "move_forward") 
	_move_axis = Vector2(h, -v) # -Z is forward
	jump_pressed = Input.is_action_pressed("jump")

	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y *= 0.5 #! Enables Short Hopping? 
		#TODO - MAKE CONSTANT 

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			velocity.z = -50


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	if jump_pressed && is_on_floor():
		velocity.y = JUMP_VELOCITY


	if _move_axis.length_squared() > 0:
		# Forward Vector of Camera (with y-axis removed)
		# Vector3(-camera.basis.z.x, 0, -camera.basis.z.z).normalized()

		# Rotate the Player
		var target_angle = _move_axis.angle_to(Vector2.UP) + camera.rotation.y #atan2( _move_axis.y, -_move_axis.x) + (PI/2) # WHY DO I HAVE TO INVERT THE X AXIS??
		var angular_difference = wrapf(target_angle - rotation.y, -PI, PI) # Find Shortest path to the target angle
		rotation.y += clamp(delta * ANGULAR_SPEED, 0, abs(angular_difference)) * sign(angular_difference)
		# rotation.y = target_angle # Snap Movement (could be useful? like if standing still)

		# Move the Player
		# var target_direction = Vector3(0,target_angle,0) * Vector3.FORWARD
		# velocity.x = target_direction.x * _move_axis.x * ACCEL_SPEED
		# velocity.z = target_direction.z * _move_axis.y * ACCEL_SPEED
	
		velocity.x += _move_axis.x * ACCEL_SPEED
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		velocity.z += _move_axis.y * ACCEL_SPEED
		velocity.z = clamp(velocity.z, -MAX_SPEED, MAX_SPEED)

		pass
		
	# velocity.x *= friction
	# velocity.z *= friction

	velocity.x -= sign(velocity.x) * friction * (0.5 * ACCEL_SPEED)
	velocity.z -= sign(velocity.z) * friction * (0.5 * ACCEL_SPEED)
	
	if abs(velocity.x) < 0.2:
		velocity.x = 0
	if abs(velocity.z) < 0.2:
		velocity.z = 0
				
				
	print(velocity)
	move_and_slide()
