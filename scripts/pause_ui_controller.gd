class_name PauseUIControl
extends Control

var gm : GameManager
var options_ui_res = preload("res://ui_controls/options_ui_control.tscn")
var options_ui

func _ready():
	reset_focus()
	return

func setup_and_show():
	reset_focus()
	visible = true


func reset_focus():
	$ButtonPanelContainer/ButtonVBoxContainer/ResumeBTN.grab_focus()
	return


func _on_resume_btn_pressed():
	start_resuming()
	pass


func _on_restart_btn_pressed():
	pass # Replace with function body.


func _on_options_btn_pressed():
	# remove focus from current node
	get_viewport().gui_get_focus_owner().release_focus()
	$ButtonPanelContainer/ButtonVBoxContainer/ResumeBTN.focus_mode = FOCUS_NONE
	$ButtonPanelContainer/ButtonVBoxContainer/RestartBTN.focus_mode = FOCUS_NONE
	$ButtonPanelContainer/ButtonVBoxContainer/OptionsBTN.focus_mode = FOCUS_NONE
	$ButtonPanelContainer/ButtonVBoxContainer/ExitLevelBTN.focus_mode = FOCUS_NONE

	options_ui = options_ui_res.instantiate()
	options_ui.remove_options_ui.connect(_remove_options_ui)	
	add_child(options_ui)

func _remove_options_ui():
	options_ui.queue_free()
	$ButtonPanelContainer/ButtonVBoxContainer/ResumeBTN.focus_mode = FOCUS_ALL
	$ButtonPanelContainer/ButtonVBoxContainer/ResumeBTN.grab_focus()
	$ButtonPanelContainer/ButtonVBoxContainer/RestartBTN.focus_mode = FOCUS_ALL
	$ButtonPanelContainer/ButtonVBoxContainer/OptionsBTN.focus_mode = FOCUS_ALL
	$ButtonPanelContainer/ButtonVBoxContainer/ExitLevelBTN.focus_mode = FOCUS_ALL


func _on_exit_level_btn_pressed():
	pass # Replace with function body.

func start_resuming():
	# TODO : Hide any dialogues/modals that are shown? idk if this is needed
	gm.should_resume()
	return
