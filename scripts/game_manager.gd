class_name GameManager
extends Node

# Timer Variables
@onready var one_second_timer : Timer = get_child(0) as Timer
# can pause timer when game is paused, unpause when game is unpaused.
# var time_count : int = 0 # TODO - Remove? replaced w/ new method "get_elapsed_time"
var tmin : int = 0
var tsec : int = 0
const time_format_str = "%d:%02d"

# Checkpoint Variables
@export var checkpoints : Array[Checkpoint]
@export var current_checkpoint : Checkpoint

# Collectable Variables
var current_collectable_count : int = 0
@export var level_collectable_count : int = -1

# UI Variables
@export var game_ui : Control
var d_collectable_current_label : Control
var d_timer_label : Control

# Player Reference Variables
@export var player_ref : PlayerMove
@export var camera_ref : PlayerCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize UI
	if game_ui == null:
		game_ui = get_tree().get_root().find_child("GameUIControl", true)
	d_collectable_current_label = game_ui.find_child("DCollectableCurrentLabel", true)
	d_timer_label = game_ui.find_child("DTimerLabel", true)
	d_collectable_current_label.text = str(0)
	game_ui.find_child("DCollectableTotalLabel", true).text = str(level_collectable_count)
	
	# Checkpoints
	for chp in checkpoints:
		print(chp.body_entered.get_connections())
		print("CONNECTING!", chp)
		chp.body_entered.connect(on_checkpoint_enter)
		if chp.is_level_start:
			current_checkpoint = chp
	
	# TODO - Need to initalize variables? After then, start timer
	# NOT collectables though - those are a seperate script 
	
	one_second_timer.start()
	return

func on_timer_tick():
	# time_count += 1 # TODO - Remove? (can get w/ tmin * 60 + tsec)

	if tsec >= 59:
		tsec = 0
		tmin += 1
	else: 
		tsec += 1
	
	d_timer_label.text = time_format_str % [tmin, tsec]  #str(tmin) + ":" + str(tsec)
	return

func get_elapsed_time():
	return tmin * 60 + tsec

func increment_collectable_count():
	current_collectable_count += 1
	d_collectable_current_label.text = str(current_collectable_count)
	
func on_checkpoint_enter(body : Node3D):
	print("ENTERED CHECPOINT")
	if body is PlayerMove:
		pass
	return
	
func restart_from_checkpoint():
	player_ref.position = current_checkpoint.position
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		print("mouse button event at ", event.position)
		restart_from_checkpoint()
