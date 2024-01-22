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
@export var death_ui : DeathUIControl
@export var pause_ui : PauseUIControl

var _is_dying : bool = false

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
	
	pause_ui.gm = self
	pause_ui.visible = false
	
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
	
func _input(_event):
	# Pause
	if Input.is_action_just_pressed("pause_game"):
		if not get_tree().paused:
			should_pause()
		else:
			should_resume()

func player_die():
	# Lock (need to finish dying before can die again)
	if _is_dying:
		return
	_is_dying = true
	# Stop Timers
	one_second_timer.paused = true
	# Disable Camera Follow
	camera_ref.set_physics_process(false)
	
	# TODO : Play Player Death Anim?
	
	# Fade Out Anim
	death_ui.animation_player.play("death_fade_in")
	await death_ui.animation_player.animation_finished
	# call RestartFromCheckpoint to reset level state
	restart_from_checkpoint()
	# Re-Enable Camera Follow
	camera_ref.set_physics_process(true)
	# 0.25 second delay?
	$DeathResetTimer.start()
	await $DeathResetTimer.timeout
	
	# TODO : Allow player movement
	
	# Start timer again
	one_second_timer.paused = false
	# Fade In Anim
	death_ui.animation_player.play_backwards("death_fade_in")
	await death_ui.animation_player.animation_finished
	# Unlock
	_is_dying = false
	return

func should_pause():
	# TODO : Check if can pause (cannot pause if dying)
	if _is_dying:
		return
	
	pause_ui.setup_and_show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	
func should_resume():
	if get_tree().paused:
		pause_ui.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
