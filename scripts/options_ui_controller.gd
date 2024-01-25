extends Control

@export var mouseSenseSlider : HSlider
@export var mouseXInvertBox : CheckBox
@export var mouseYInvertBox : CheckBox

@export var contrSenseSlider : HSlider
@export var contrXInvertBox : CheckBox
@export var contrYInvertBox : CheckBox

@export var audioMusicSlider : HSlider
@export var audioSFXSlider : HSlider # Or VSliders? Maybe base class?

func _ready():
	update_gui_from_settings()
	pass

# Update slider/toggle values based on values in UserSettings
func update_gui_from_settings():
	mouseSenseSlider.value = UserSettings.m_cam_sense
	mouseXInvertBox.button_pressed = UserSettings.m_invert_x
	mouseYInvertBox.button_pressed = UserSettings.m_invert_y
	
	contrSenseSlider.value = UserSettings.c_cam_sense
	contrXInvertBox.button_pressed = UserSettings.c_invert_x
	contrYInvertBox.button_pressed = UserSettings.c_invert_y

	audioMusicSlider.value = UserSettings.s_music_level
	audioSFXSlider.value = UserSettings.s_sfx_level
	return

func update_user_settings():
	# Set user setting values according to UI elements
	# OR Do it by signals?
	
	
	# Save to disk
	UserSettings.save_settings()
	return

# TODO - Finish making functions and connect them in editor
func _on_mouse_sense_slider_drag_ended(value_changed : bool):
	if value_changed:
		UserSettings.m_cam_sense = mouseSenseSlider.value

func _on_controller_sense_slider_drag_ended(value_changed : bool):
	if value_changed:
		UserSettings.c_cam_sense = contrSenseSlider.value

