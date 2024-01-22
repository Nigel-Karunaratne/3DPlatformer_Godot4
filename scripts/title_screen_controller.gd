extends Control

@export var focus_start : Control

# Called when the node enters the scene tree for the first time.
func _ready():
	focus_start.grab_focus()

func _on_play_btn_pressed():
	return

func _on_options_btn_pressed():
	return

func _on_exit_btn_pressed():
	# TODO : Show Warning?
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	# save objects can recieve this notification and then finish saving

func _notification(noti):
	if noti == NOTIFICATION_WM_CLOSE_REQUEST: # 'X' button pressed on window OR exot btn pressed
		_exit_game()

func _exit_game():
	print("EXIT GAME")
	get_tree().quit(0)
