class_name LevelSelectButton
extends Button

@export var level : GameDataManager.Levels
var lname : String
var time : String
var collected : String

signal selected(name, time, collected)

#Note - Must be manually called
func setup(n_level : GameDataManager.Levels):
	level = n_level
	var data = GameDataManager.get_level_info(level)
	lname = str(data['name'])
	# if player has not played level, time should reflect that instead of displaying -1
	if data['time'] < 0:
		time = "~"
	else:
		time = data['time_str']
	collected = str(data['collectable'])

func _on_focus_entered():
	emit_signal('selected', lname, time, collected)
	pass

func _on_mouse_entered():
	grab_focus()
	emit_signal('selected', lname, time, collected)
	pass

func _on_pressed():
	# Change level
	LevelManager.change_scene_with_fade_enum(level)
