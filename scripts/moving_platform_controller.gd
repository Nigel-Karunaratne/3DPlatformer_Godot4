extends Node3D

@onready var path_follow : PathFollow3D = $PathFollow3D
@onready var platform : AnimatableBody3D = $PathFollow3D/AnimatableBody3D

enum MovingPlatformType {
	LINEAR_BACK_AND_FORTH,
	EASED_BACK_AND_FORTH
}

@export var speed = 10
@export var type: MovingPlatformType = MovingPlatformType.LINEAR_BACK_AND_FORTH
@export var interp_curve: Curve

var _going_forward = true


func _ready():
	# match type:
	# 	MovingPlatformType.BACK_AND_FORTH:
	path_follow.loop = false

func _process(delta):
	match type:
		MovingPlatformType.LINEAR_BACK_AND_FORTH:
			if (_going_forward and path_follow.progress_ratio >= 1) or (not _going_forward and path_follow.progress_ratio <= 0):
				_going_forward = not _going_forward
			path_follow.progress += delta * speed * (1 if _going_forward else -1)


	return