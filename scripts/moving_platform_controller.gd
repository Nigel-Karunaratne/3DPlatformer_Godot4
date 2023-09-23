extends Path3D

@onready var path_follow : PathFollow3D = $PathFollow3D
@onready var platform : AnimatableBody3D = $PathFollow3D/AnimatableBody3D
@onready var player_detect_area : Area3D = $PathFollow3D/PlayerDetectionArea3D

enum MovingPlatformType {
	BACK_AND_FORTH,
	PLAYER_ACTIVATED
}

@export var type: MovingPlatformType = MovingPlatformType.BACK_AND_FORTH
@export var speed = 10
@export var end_delay = 1.5
@export var transition : Tween.TransitionType = Tween.TRANS_LINEAR

var _tween : Tween

func _ready():
	match type:
		MovingPlatformType.BACK_AND_FORTH:
			_tween = create_tween()
			_tween.set_trans(transition)
			_tween.set_loops()
			_tween.tween_property(path_follow, "progress_ratio", 1, curve.get_baked_length() / speed)
			_tween.tween_interval(end_delay)
			_tween.tween_property(path_follow, "progress_ratio", 0, curve.get_baked_length() / speed)
			_tween.tween_interval(end_delay)
		MovingPlatformType.PLAYER_ACTIVATED:
			player_detect_area.body_entered.connect(_player_activated_body_entered)
			player_detect_area.body_exited.connect(_player_activated_body_exited)

func end_tween():
	_tween.kill();

func _player_activated_body_entered(body:Node3D):
	if body is PlayerMove:
		if _tween:
			_tween.kill()
		_tween = create_tween()
		_tween.set_trans(transition)
		_tween.tween_property(path_follow, "progress_ratio", 1, (curve.get_baked_length() - path_follow.progress) / speed)
		# print("progress: ", path_follow.progress, "\n;length: ", curve.get_baked_length())

func _player_activated_body_exited(body:Node3D):
	if body is PlayerMove:
		if _tween:
			_tween.kill()
		_tween = create_tween()
		_tween.set_trans(transition)
		_tween.tween_property(path_follow, "progress_ratio", 0, (path_follow.progress) / speed)
		# print("progress: ", path_follow.progress, "\n;length: ", curve.get_baked_length())
