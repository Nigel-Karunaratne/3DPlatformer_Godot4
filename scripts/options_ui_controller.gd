extends Control

@export var mouseSenseSlider : HSlider
@export var mouseXInvertBox : CheckBox
@export var mouseYInvertBox : CheckBox

@export var contrSenseSlider : HSlider
@export var contrXInvertBox : CheckBox
@export var contrYInvertBox : CheckBox

@export var audioMusicSlider : HSlider
@export var audioSFXSlider : HSlider # Or VSliders? Maybe base class?

var intermediary_values = {
	"m_cam_sense": 0.25,
	"m_invert_x": true,
	"m_invert_y": false,
	
	"c_cam_sense": 150,
	"c_invert_x": false,
	"c_invert_y": true,
	
	"s_music_level": 1.0,
	"s_sfx_level": 1.0
}

signal remove_options_ui

func _ready():
	#call_deferred("update_gui_from_settings")
	#call_deferred("_setup_intermediary")
	_setup_intermediary()
	update_gui_from_intermediary()
	mouseSenseSlider.grab_focus()

func _input(_event):
	if Input.is_action_just_pressed("pause_game"):
		# Quit menu w/out saving
		get_viewport().set_input_as_handled()
		_on_btn_quit_pressed()

func _setup_intermediary():
	intermediary_values["m_cam_sense"] = UserSettings.m_cam_sense
	intermediary_values["m_invert_x"] = UserSettings.m_invert_x
	intermediary_values["m_invert_y"] = UserSettings.m_invert_y
	intermediary_values["c_cam_sense"] = UserSettings.c_cam_sense
	intermediary_values["c_invert_x"] = UserSettings.c_invert_x
	intermediary_values["c_invert_y"] = UserSettings.c_invert_y
	intermediary_values["s_music_level"] = UserSettings.s_music_level
	intermediary_values["s_sfx_level"] = UserSettings.s_sfx_level
	print('cam sense IS: ', intermediary_values["m_cam_sense"])

# Update slider/toggle values based on values in UserSettings
func update_gui_from_settings():
	print("UPDATING GUI")
	mouseSenseSlider.value = UserSettings.m_cam_sense
	mouseXInvertBox.button_pressed = UserSettings.m_invert_x
	mouseYInvertBox.button_pressed = UserSettings.m_invert_y
	
	contrSenseSlider.value = UserSettings.c_cam_sense
	contrXInvertBox.button_pressed = UserSettings.c_invert_x
	contrYInvertBox.button_pressed = UserSettings.c_invert_y

	audioMusicSlider.value = UserSettings.s_music_level
	audioSFXSlider.value = UserSettings.s_sfx_level
	return

func update_gui_from_intermediary():
	print("UPDATING GUI")
	mouseSenseSlider.value = intermediary_values["m_cam_sense"]
	mouseXInvertBox.button_pressed = (intermediary_values["m_invert_x"])
	mouseYInvertBox.set_pressed_no_signal(intermediary_values["m_invert_y"])
	contrSenseSlider.value = intermediary_values["c_cam_sense"]
	contrXInvertBox.set_pressed_no_signal(intermediary_values["c_invert_x"])
	contrYInvertBox.set_pressed_no_signal(intermediary_values["c_invert_y"])
	audioMusicSlider.value = intermediary_values["s_music_level"]
	audioSFXSlider.value = intermediary_values["s_sfx_level"]
	return

func _on_mouse_sense_slider_drag_ended(value_changed : bool):
	#if value_changed:
	intermediary_values["m_cam_sense"] = mouseSenseSlider.value
	print("MCAMSENSE CHANGED: ", mouseSenseSlider.value)

func _on_controller_sense_slider_drag_ended(value_changed : bool):
	if value_changed:
		intermediary_values["c_cam_sense"] = int(contrSenseSlider.value) # controller sense is int

func _on_mouse_invert_x_toggled(button_pressed : bool):
	intermediary_values["m_invert_x"] = button_pressed

func _on_mouse_invert_y_toggled(button_pressed : bool):
	intermediary_values["m_invert_y"] = mouseYInvertBox.button_pressed

func _on_controller_invert_x_toggled(button_pressed : bool):
	intermediary_values["c_invert_x"] = contrXInvertBox.button_pressed

func _on_controller_invert_y_toggled(button_pressed : bool):
	intermediary_values["c_invert_y"] = contrYInvertBox.button_pressed

func _on_audio_music_slider_drag_ended(value_changed : bool):
	if value_changed:
		intermediary_values["s_music_level"] = audioMusicSlider.value

func _on_audio_sfx_slider_drag_ended(value_changed : bool):
	if value_changed:
		intermediary_values["s_sfx_level"] = audioSFXSlider.value

func _on_btn_save_pressed():
	_update_usersettings_from_intermediary()
	UserSettings.save_settings()

func _update_usersettings_from_intermediary():
	print(intermediary_values["m_cam_sense"], UserSettings.m_cam_sense)
	UserSettings.m_cam_sense = intermediary_values["m_cam_sense"]
	UserSettings.m_invert_x = intermediary_values["m_invert_x"]
	UserSettings.m_invert_y = intermediary_values["m_invert_y"]
	UserSettings.c_cam_sense = intermediary_values["c_cam_sense"]
	UserSettings.c_invert_x = intermediary_values["c_invert_x"]
	UserSettings.c_invert_y = intermediary_values["c_invert_y"]
	UserSettings.s_music_level = intermediary_values["s_music_level"]
	UserSettings.s_sfx_level = intermediary_values["s_sfx_level"]
	print(intermediary_values["m_cam_sense"], UserSettings.m_cam_sense)

func _on_btn_reset_pressed():
	intermediary_values = UserSettings.DEFAULTS
	update_gui_from_intermediary()

func _on_btn_quit_pressed():
	emit_signal("remove_options_ui")
	# queue_free()
