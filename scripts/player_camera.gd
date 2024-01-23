class_name PlayerCamera
extends SpringArm3D

#TODO - Add Bounds for vertical rotation

@export var player : Node3D
const CAMERA_SPEED = 0.9

var controller_look_h_speed = 150
var controller_look_v_speed = 150

var mouse_look_h_speed = 0.25
var mouse_look_v_speed = 0.25

var controller_invert_look_h = false
var controller_invert_look_v = true

var mouse_invert_look_h = true
var mouse_invert_look_v = false

var mouse_input : Vector2 = Vector2.ZERO

var offset = Vector3(0,1,0)

# Smoothing Variables
var smooth_speed = 15
const SMOOTH_STOP_THRESHOLD = 0.01

# Reset Camera Triggers
var is_resetting_camera = false
const RESET_SPEED = 6.5
const RESET_ANGLE_THRESHOLD = 0.05
var _reset_target_angle: float

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if player != null:
		add_excluded_object(player.get_rid())
		pass
	
	# Setup sensitivities from UserSettings
	# NOTE: This should be fine, in a normal game the title screen
	#   is loaded before any scene w/ this camera
	change_sensitivities()


func _unhandled_input(event):
	# Mouse Input (has to be handled here for some reason D: )
	if event is InputEventMouseMotion:
		# print(event.relative)
		
		if not is_resetting_camera:
			rotation_degrees.x += (event.relative.y * mouse_look_v_speed) * (-1 if mouse_invert_look_v else 1)
			rotation_degrees.y += (event.relative.x * mouse_look_h_speed) * (-1 if mouse_invert_look_h else 1)
			# rotation_degrees.x = clamp(rotation_degrees.x, -90, 30)
			# rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
		pass

	# Toggle Mouse Cursor
#	elif event is InputEventKey and event.pressed:
#		if event.keycode == KEY_ESCAPE:
#			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#			else:
#				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#		elif event.keycode == KEY_R: #!TEMP OVERHEAD CAMERA BUTTON
#			rotation_degrees.x = -90
#			rotation_degrees.y = -180
#			rotation_degrees.z = 0
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Smooth move to Player Location
	if player != null:
		var distance = (player.position + offset) - position
		# print(distance.length())
		if distance.length() > SMOOTH_STOP_THRESHOLD:
			# position = position.move_toward(player.position + offset, CAMERA_SPEED) # LINEAR MOTION
			position += distance * smooth_speed * delta

		# Reset Camera Rotation
		if Input.is_action_just_pressed("reset_camera"):
			# rotation.y = player.rotation.y
			is_resetting_camera = true
			_reset_target_angle = player.rotation.y

		if is_resetting_camera == true:
			rotation.y = lerp_angle(rotation.y, _reset_target_angle, delta * RESET_SPEED) # Rotate
			var angle_delta = abs(fposmod(_reset_target_angle - rotation.y + PI, PI*2) - PI) # Get Difference between angles
			if (angle_delta < RESET_ANGLE_THRESHOLD):
				is_resetting_camera = false
			pass




	# Controller Input
	var look_h = Input.get_axis("look_left", "look_right") * (-1 if controller_invert_look_h else 1)
	var look_v = Input.get_axis("look_down", "look_up") * (-1 if controller_invert_look_v else 1)

	#Rotate Camera
	if not is_resetting_camera:
		rotation_degrees.x -= look_v * delta * controller_look_v_speed
		rotation_degrees.y -= look_h * delta * controller_look_h_speed
	rotation_degrees.x = clamp(rotation_degrees.x, -70, 30)
	rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
	# rotate(Vector3.UP, look_h * delta * controller_look_h_speed)
	# rotate_object_local(Vector3.RIGHT, look_v * delta * controller_look_v_speed)
	#print(rotation)
	
	return

func change_sensitivities():
	controller_look_h_speed = UserSettings.c_cam_x_sense
	controller_look_v_speed = UserSettings.c_cam_y_sense
	controller_invert_look_h = UserSettings.c_invert_x
	controller_invert_look_v = UserSettings.c_invert_y
	
	mouse_look_h_speed = UserSettings.m_cam_x_sense
	mouse_look_v_speed = UserSettings.m_cam_y_sense
	mouse_invert_look_h = UserSettings.m_invert_x
	mouse_invert_look_v = UserSettings.m_invert_y
	return
