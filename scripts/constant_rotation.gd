extends Node3D

@export var rotation_speed : float = 1
@export var rotation_axis : Vector3 = Vector3(0.0, 0.0, 1.0)

func _ready():
	rotation_axis = rotation_axis.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_object_local(rotation_axis, rotation_speed * delta)

func set_rotation_axis(new_rotation_axis : Vector3):
	rotation_axis = new_rotation_axis.normalized()
