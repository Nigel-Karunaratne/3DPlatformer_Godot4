extends Node

var _ui = preload("res://ui_controls/fade_ui.tscn")
var _instance
var _anim : AnimationPlayer
var _faded_in := false

# Called when the node enters the scene tree for the first time.
func _ready():
	_instance = _ui.instantiate()
	add_child(_instance)
	_anim = _instance.get_child("AnimationPlayer") as AnimationPlayer
	_anim.play("RESET")
	pass

func fade_in():
	if not _faded_in:
		_anim.play("fade_in")

func fade_out():
	if _faded_in:
		_anim.play("fade_out")
