extends Node

# AUTOLOAD : UserSettings

var m_cam_x_sense : float = 0.25
var m_cam_y_sense : float = 0.25
var m_invert_x : bool = true
var m_invert_y : bool = false

var c_cam_x_sense : int = 150
var c_cam_y_sense : int = 150
var c_invert_x : bool = false
var c_invert_y : bool = true

var s_music_level : float = 1.0
var s_sfx_level : float = 1.0

const DEFAULTS = {
	"m_cam_x_sense": 0.25,
	"m_cam_y_sense": 0.25,
	"m_invert_x": true,
	"m_invert_y": false,
	
	"c_cam_x_sense": 150,
	"c_cam_y_sense": 150,
	"c_invert_x": false,
	"c_invert_y": true,
	
	"s_music_level": 1.0,
	"s_sfx_level": 1.0
}
