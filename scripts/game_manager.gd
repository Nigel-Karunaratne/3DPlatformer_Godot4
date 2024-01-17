class_name GameManager
extends Node

signal restarting_level

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
var collectables_since_last_checkpoint : Array[Collectable]
var collectable_count_at_chp : int = 0
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

func increment_collectable_count(col : Collectable):
	current_collectable_count += 1
	
	collectables_since_last_checkpoint.append(col)
	col.visible = false
	col.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	
	d_collectable_current_label.text = str(current_collectable_count)
	
func on_checkpoint_enter(chp : Checkpoint):
	current_checkpoint = chp
	collectable_count_at_chp = current_collectable_count
	collectables_since_last_checkpoint.clear()
	return
	
func restart_from_checkpoint():
	emit_signal("restarting_level")
	player_ref.position = current_checkpoint.position
	for col in collectables_since_last_checkpoint:
		col.visible = true
		col.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	current_collectable_count = collectable_count_at_chp
	d_collectable_current_label.text = str(current_collectable_count)
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		print("mouse button event at ", event.position)
		restart_from_checkpoint()
