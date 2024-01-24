extends Node

# AUTOLOAD : UserSettings
const FILE_PATH = "user://usersettings.cfg"

var m_cam_sense : float = 0.25
var m_invert_x : bool = true
var m_invert_y : bool = false

var c_cam_sense : int = 150
var c_invert_x : bool = false
var c_invert_y : bool = true

var s_music_level : float = 1.0
var s_sfx_level : float = 1.0

const DEFAULTS = {
	"m_cam_sense": 0.25,
	"m_invert_x": true,
	"m_invert_y": false,
	
	"c_cam_sense": 150,
	"c_invert_x": false,
	"c_invert_y": true,
	
	"s_music_level": 1.0,
	"s_sfx_level": 1.0
}

func save_settings():
	var config = ConfigFile.new()
	
	config.set_value("M", "m_cam_sense", m_cam_sense)
	config.set_value("M", "m_invert_x", m_invert_x)
	config.set_value("M", "m_invert_y", m_invert_y)
	
	config.set_value("C", "c_cam_sense", c_cam_sense)
	config.set_value("C", "c_invert_x", c_invert_x)
	config.set_value("C", "c_invert_y", c_invert_y)
	
	config.set_value("S", "s_music_level", s_music_level)
	config.set_value("S", "s_sfx_level", s_sfx_level)
	var error = config.save(FILE_PATH)
	if error != OK:
		printerr("Error w/ save_settings: ", error)
	return

func load_settings():
	var config = ConfigFile.new()
	var error = config.load(FILE_PATH)
	
	if error != OK:
		print("Error while loading file: ", error)
		if error == ERR_FILE_NOT_FOUND: # TODO - Handle more errors? Log errors?
			_save_default_settings_file()
		return
		
	
	config.get_value("M", "m_cam_sense", DEFAULTS["m_cam_sense"])
	config.get_value("M", "m_invert_x", DEFAULTS["m_invert_x"])
	config.get_value("M", "m_invert_y", DEFAULTS["m_invert_y"])
	
	config.get_value("C", "c_cam_sense", DEFAULTS["c_cam_sense"])
	config.get_value("C", "c_invert_x", DEFAULTS["c_invert_x"])
	config.get_value("C", "c_invert_y", DEFAULTS["c_invert_y"])
	
	config.get_value("S", "s_music_level", DEFAULTS["s_music_level"])
	config.get_value("S", "s_sfx_level", DEFAULTS["s_sfx_level"])
	return
	
func _save_default_settings_file():
	var config = ConfigFile.new()
	config.set_value("M", "m_cam_sense", DEFAULTS["m_cam_sense"])
	config.set_value("M", "m_invert_x", DEFAULTS["m_invert_x"])
	config.set_value("M", "m_invert_y", DEFAULTS["m_invert_y"])
	
	config.set_value("C", "c_cam_sense", DEFAULTS["c_cam_sense"])
	config.set_value("C", "c_invert_x", DEFAULTS["c_invert_x"])
	config.set_value("C", "c_invert_y", DEFAULTS["c_invert_y"])
	
	config.set_value("S", "s_music_level", DEFAULTS["s_music_level"])
	config.set_value("S", "s_sfx_level", DEFAULTS["s_sfx_level"])
	var error = config.save(FILE_PATH)
	if error != OK:
		printerr("Error with creating a default config file: ", error)
	return

func _ready():
	load_settings()
	return
