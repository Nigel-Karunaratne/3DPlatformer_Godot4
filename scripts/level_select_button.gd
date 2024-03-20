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
	time = data['time_str']
	collected = str(data['collectable'])

func _on_focus_entered():
	emit_signal('selected', lname, time, collected)
	pass

func _on_pressed():
	# Get level name
	LevelManager.change_scene_with_fade_enum(level)
	
