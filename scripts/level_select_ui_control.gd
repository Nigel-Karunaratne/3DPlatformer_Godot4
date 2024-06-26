class_name LevelSelectUI
extends Control

@export var level_name_label : Label
@export var best_time_label : Label
@export var button_hbox_container : HBoxContainer
@export var level_select_button = preload("res://ui_controls/level_select_button.tscn")

signal new_level_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Generate Buttons and parent them to Hboxcontainer
	var start_selected_level = 1
	for i in range(1,GameDataManager.LEVEL_COUNT+1):
		var btn = level_select_button.instantiate() as LevelSelectButton
		btn.setup(i)
		#btn.selected.connect(update_ui.bind([btn.lname, btn.time, btn.collected]))
		btn.selected.connect(update_ui)
		button_hbox_container.add_child(btn)
		if i == start_selected_level:
			btn.grab_focus()
		pass
	pass

func update_ui(lname, time, collected):
	level_name_label.text = lname
	best_time_label.text = "Best Time: %s" % time
	emit_signal("new_level_selected")
	#TODO - show collected badge
	#TODO - update background as well
