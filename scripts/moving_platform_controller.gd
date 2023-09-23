extends Path3D

@onready var path_follow : PathFollow3D = $PathFollow3D
@onready var platform : AnimatableBody3D = $PathFollow3D/AnimatableBody3D

enum MovingPlatformType {
	LINEAR_BACK_AND_FORTH,
	QUAD_BACK_AND_FORTH
}

@export var speed = 10
@export var end_delay = 1.5
@export var type: MovingPlatformType = MovingPlatformType.LINEAR_BACK_AND_FORTH
@export var interp_curve: Curve

var _tween : Tween

func _ready():
	# match type:
	# 	MovingPlatformType.BACK_AND_FORTH:
	path_follow.loop = false
	_tween = create_tween()

	match type:
		MovingPlatformType.LINEAR_BACK_AND_FORTH:
			_tween.set_trans(Tween.TRANS_LINEAR)
			_tween.set_loops()
			_tween.tween_property(path_follow, "progress", curve.get_baked_length(), curve.get_baked_length() / speed)
			_tween.tween_interval(end_delay)
			_tween.tween_property(path_follow, "progress", 0, curve.get_baked_length() / speed)
			_tween.tween_interval(end_delay)
		MovingPlatformType.QUAD_BACK_AND_FORTH:
			_tween.set_trans(Tween.TRANS_QUAD)
			_tween.set_loops()
			_tween.tween_property(path_follow, "progress", curve.get_baked_length(), curve.get_baked_length() / speed)
			_tween.tween_interval(end_delay)
			_tween.tween_property(path_follow, "progress", 0, curve.get_baked_length() / speed)
			_tween.tween_interval(end_delay)

func end_tween():
	_tween.kill();