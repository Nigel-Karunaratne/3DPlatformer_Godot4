class_name GameManager
extends Node

@onready var one_second_timer : Timer = get_child(0) as Timer
# can pause timer when game is paused, unpause when game is unpaused.
var time_count : int = 0

var current_collectable_count : int = 0
@export var level_collectable_count : int = -1

@export var game_ui : Control
var d_collectable_current_label : Control
var d_timer_label : Control

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
	time_count += 1
	# TODO - Format Time
	d_timer_label.text = str(time_count)
	return

func increment_collectable_count():
	current_collectable_count += 1
	d_collectable_current_label.text = str(current_collectable_count)