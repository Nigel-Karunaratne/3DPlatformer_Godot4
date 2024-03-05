extends Node

const level_path = "res://level_scenes/%s"
const MAIN_MENU_SCENE = "res://level_scenes/main_menu.tscn"
const LEVEL_SELECT_SCENE = "res://level_scenes/level_select.tscn"

func get_level_name(level: GameDataManager.Levels):
	return level_path % (str(level) + ".tscn")

func _load_level(level_filename : String):
	var path = level_path % level_filename
	ResourceLoader.load_threaded_request(path)
	
	return
