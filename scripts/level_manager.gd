extends Node

const LEVEL_PATH = "res://level_scenes/%s"
const MAIN_MENU_SCENE = "res://level_scenes/main_menu.tscn"
const LEVEL_SELECT_SCENE = "res://level_scenes/level_select.tscn"

const DELAY_BETWEEN_LOAD = 1.5

const LEVEL_FILE_NAMES = {
	1: "monument1",
	2: "monument2",
}

func get_level_name(level: GameDataManager.Levels):
	return LEVEL_FILE_NAMES[level]

func change_scene_with_fade_enum(level:GameDataManager.Levels):
	change_scene_with_fade(LEVEL_FILE_NAMES[level])
	pass

func change_scene_with_fade(level_filename : String, fullpath : bool = false):
	GlobalFade.fade_in()
	var path = level_filename if fullpath else (LEVEL_PATH % level_filename)+".tscn"
	var _tree = get_tree()
	ResourceLoader.load_threaded_request(path)
	await _tree.create_timer(DELAY_BETWEEN_LOAD).timeout
	while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await _tree.process_frame
	call_deferred("_go_to", path)
	return

func _go_to(filename: String):
	var scene = ResourceLoader.load_threaded_get(filename)
	get_tree().change_scene_to_packed(scene)
	GlobalFade.fade_out()
	pass
