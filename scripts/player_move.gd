extends CharacterBody3D

# Object References
@export var camera : Node3D

# Movement Variables
const ACCEL_SPEED = 10
const MAX_SPEED = 9
const GRAVITY = 26
const JUMP_VELOCITY = 12
const ANGULAR_SPEED = TAU * 2

var friction = 0.7

# Input Processing variables
var _move_axis = Vector3.ZERO
var jump_pressed = false

func _process(_delta):
	var h = Input.get_axis("move_left", "move_right")
	var v = Input.get_axis("move_back", "move_forward") 
	_move_axis = Vector3(h, 0, -v).normalized() # -Z is forward
	

	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y *= 0.5 #! Enables Short Hopping? 
		#TODO - MAKE CONSTANT 

func _unhandled_input(event):
	jump_pressed = Input.is_action_just_pressed("jump")

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			velocity.z = -50


func _physics_process(delta):
	_move_axis = _move_axis.rotated(Vector3.UP, camera.rotation.y).normalized();
	velocity.x = _move_axis.x * ACCEL_SPEED
	velocity.z = _move_axis.z * ACCEL_SPEED

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	if jump_pressed && is_on_floor():
		velocity.y = JUMP_VELOCITY


	if _move_axis.length_squared() > 0:
		# Forward Vector of Camera (with y-axis removed)
		# Vector3(-camera.basis.z.x, 0, -camera.basis.z.z).normalized()

		# Rotate the Player
		var look_direction = Vector2(-velocity.z, -velocity.x)
		var target_angle = look_direction.angle()
		rotation.y = target_angle

				# var target_angle = _move_axis.angle_to(Vector3.FORWARD) #+ camera.rotation.y #atan2( _move_axis.y, -_move_axis.x) + (PI/2) # WHY DO I HAVE TO INVERT THE X AXIS??
				# var angular_difference = wrapf(target_angle - rotation.y, -PI, PI) # Find Shortest path to the target angle
				# rotation.y += clamp(delta * ANGULAR_SPEED, 0, abs(angular_difference)) * sign(angular_difference)
		# rotation.y = target_angle # Snap Movement (could be useful? like if standing still)


		# Move the Player
		# var target_direction = Vector3(0,target_angle,0) * Vector3.FORWARD
		# velocity.x = target_direction.x * _move_axis.x * ACCEL_SPEED
		# velocity.z = target_direction.z * _move_axis.y * ACCEL_SPEED

		# var camera_x = camera.global_transform.basis.x
		# var camera_z = camera.global_transform.basis.z

		# velocity.x += _move_axis.x * ACCEL_SPEED
		# velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		# velocity.z += _move_axis.y * ACCEL_SPEED
		# velocity.z = clamp(velocity.z, -MAX_SPEED, MAX_SPEED)

		# _move_axis = _move_axis.rotated(-camera.rotation.y).normalized();
		#! velocity.x += _move_axis.x * ACCEL_SPEED
		#! velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		#! velocity.z += _move_axis.z * ACCEL_SPEED
		#! velocity.z = clamp(velocity.z, -MAX_SPEED, MAX_SPEED)
		# velocity.x = _move_axis.x * ACCEL_SPEED
		# velocity.z = _move_axis.z * ACCEL_SPEED

		# velocity += Vector3(_move_axis.x * ACCEL_SPEED, velocity.y, _move_axis.y * ACCEL_SPEED) * camera_z
		
		pass
		
	# velocity.x *= friction
	# velocity.z *= friction

	#! velocity.x -= sign(velocity.x) * friction * (0.5 * ACCEL_SPEED)
	#! velocity.z -= sign(velocity.z) * friction * (0.5 * ACCEL_SPEED)
	
	#! if abs(velocity.x) < 0.2:
	#! 	velocity.x = 0
	#! if abs(velocity.z) < 0.2:
	#! 	velocity.z = 0
				
				
	# print(velocity)
	print(Vector2(velocity.x, velocity.z).length())
	move_and_slide()
