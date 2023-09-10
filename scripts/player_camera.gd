extends SpringArm3D

#TODO - Add Bounds for vertical rotation

const CONTROLLER_LOOK_H_SPEED = 1
const CONTROLLER_LOOK_V_SPEED = 1

const MOUSE_LOOK_H_SPEED = 0.25
const MOUSE_LOOK_V_SPEED = 0.25

var controller_invert_look_h = false
var controller_invert_look_v = false

var mouse_invert_look_h = false
var mouse_invert_look_v = true

var mouse_input : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	# Mouse Input (has to be handled here for some reason D: )
	if event is InputEventMouseMotion:
		# print(event.relative)

		rotate(Vector3.UP, deg_to_rad(event.relative.x * MOUSE_LOOK_H_SPEED) * (-1 if mouse_invert_look_h else 1))
		rotate_object_local(Vector3.RIGHT, deg_to_rad(event.relative.y * MOUSE_LOOK_V_SPEED) * (-1 if mouse_invert_look_v else 1))

		pass

	# Toggle Mouse Cursor
	elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Controller Input
	var look_h = Input.get_axis("look_left", "look_right") * (-1 if controller_invert_look_h else 1)
	var look_v = Input.get_axis("look_down", "look_up") * (-1 if controller_invert_look_v else 1)

	#Rotate Camera
	rotate(Vector3.UP, look_h * delta * CONTROLLER_LOOK_H_SPEED)
	rotate_object_local(Vector3.RIGHT, look_v * delta * CONTROLLER_LOOK_V_SPEED)
	#print(rotation)
	
	return
