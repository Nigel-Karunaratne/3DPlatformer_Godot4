class_name GameManager
extends Node

@onready var one_second_timer : Timer = get_child(0) as Timer
# can pause timer when game is paused, unpause when game is unpaused.
var time_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO - Need to initalize variables? After then, start timer
	# NOT collectables though - those are a seperate script 
	
	one_second_timer.start()
	return

func on_timer_tick():
	time_count += 1
	return
