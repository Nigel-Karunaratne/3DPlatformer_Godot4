extends Control

@export var mouseSenseSlider : HSlider
@export var mouseXInvertBox : CheckBox
@export var mouseYInvertBox : CheckBox

@export var contrSenseSlider : HSlider
@export var contrXInvertBox : CheckBox
@export var contrYInvertBox : CheckBox

@export var audioMusicSlider : HSlider
@export var audioSFXSlider : HSlider # Or VSliders? Maybe base class?

signal remove_options_ui

func _ready():
	call_deferred("update_gui_from_settings")
	mouseSenseSlider.grab_focus()
	#update_gui_from_settings()

func _input(_event):
	if Input.is_action_just_pressed("pause_game"):
		# Quit menu w/out saving
		get_viewport().set_input_as_handled()
		_on_btn_quit_pressed()


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

func _on_mouse_sense_slider_drag_ended(value_changed : bool):
	if value_changed:
		UserSettings.m_cam_sense = mouseSenseSlider.value

func _on_controller_sense_slider_drag_ended(value_changed : bool):
	if value_changed:
		UserSettings.c_cam_sense = int(contrSenseSlider.value) # controller sense is int

func _on_mouse_invert_x_toggled(button_pressed : bool):
	UserSettings.m_invert_x = mouseXInvertBox.button_pressed

func _on_mouse_invert_y_toggled(button_pressed : bool):
	UserSettings.m_invert_y = mouseYInvertBox.button_pressed

func _on_controller_invert_x_toggled(button_pressed : bool):
	UserSettings.c_invert_x = contrXInvertBox.button_pressed

func _on_controller_invert_y_toggled(button_pressed : bool):
	UserSettings.c_invert_y = contrYInvertBox.button_pressed

func _on_audio_music_slider_drag_ended(value_changed : bool):
	if value_changed:
		UserSettings.s_music_level = audioMusicSlider.value

func _on_audio_sfx_slider_drag_ended(value_changed : bool):
	if value_changed:
		UserSettings.s_sfx_level = audioSFXSlider.value

func _on_btn_save_pressed():
	UserSettings.save_settings()

func _on_btn_reset_pressed():
	UserSettings.reset_settings()
	UserSettings.save_settings()
	update_gui_from_settings()

func _on_btn_quit_pressed():
	emit_signal("remove_options_ui")
	# queue_free()
