class_name PauseUIControl
extends Control

var gm : GameManager

func _ready():
	reset_focus()
	return


func reset_focus():
	$ButtonPanelContainer/ButtonVBoxContainer/ResumeBTN.grab_focus()
	return


func _on_resume_btn_pressed():
	pass


func _on_restart_btn_pressed():
	pass # Replace with function body.


func _on_options_btn_pressed():
	pass # Replace with function body.


func _on_exit_level_btn_pressed():
	pass # Replace with function body.
