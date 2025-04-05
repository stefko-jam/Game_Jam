extends Control

@onready var fullscreen_button: CheckBox = $TabContainer/Video/Options/FullscreenLabel/FullscreenButton
@onready var aspect_ratio_button: OptionButton = $TabContainer/Video/Options/AspectRatioLabel/AspectRatioButton
@onready var resolution_button: OptionButton = $TabContainer/Video/Options/ResolutionLabel/ResolutionButton
@onready var vsync_button: CheckBox = $TabContainer/Video/Options/VsyncLabel/VsyncButton

@onready var master_vol_label: Label = $TabContainer/Audio/Options/MasterLabel/MasterVolumeSlider/Label
@onready var music_vol_label: Label = $TabContainer/Audio/Options/MusicLabel/MusicVolumeSlider/Label
@onready var effects_vol_label: Label = $TabContainer/Audio/Options/EffectsLabel/EffectsVolumeSlider/Label
@onready var voices_vol_label: Label = $TabContainer/Audio/Options/VoicesLabel/VoicesVolumeSlider/Label


func _ready():
	update_ui()


func update_ui():
	
	# VIDEO SETTINGS
	
	# 	Fullscreen
	fullscreen_button.set_pressed_no_signal(SettingsManager.fullscreen)
	
	# 	Aspect Ratio
	aspect_ratio_button.clear()
	
	# 	Adding options
	for i in SettingsManager.resolution_dict.keys():
		aspect_ratio_button.add_item(i)
	
	# 	Searching the current aspect ratio
	var ar_index: int = 0
	while ar_index < aspect_ratio_button.item_count:
		if SettingsManager.aspect_ratio == aspect_ratio_button.get_item_text(ar_index):
			aspect_ratio_button.select(ar_index)
		ar_index += 1
	
	# 	Resolution
	resolution_button.clear()
	for i in SettingsManager.resolution_dict.get(SettingsManager.aspect_ratio):
		resolution_button.add_item(i)
	var res_index: int = 0
	while res_index < resolution_button.item_count:
		if SettingsManager.resolution == resolution_button.get_item_text(res_index):
			resolution_button.select(res_index)
		res_index += 1
	
	# 	VSync
	vsync_button.set_pressed_no_signal(SettingsManager.vsync)
	
	
	# AUDIO SETTINGS
	master_vol_label.text = str(SettingsManager.master_volume)
	music_vol_label.text = str(SettingsManager.music_volume)
	effects_vol_label.text = str(SettingsManager.effects_volume)
	voices_vol_label.text = str(SettingsManager.voices_volume)


# SIGNALS

func _on_back_button_pressed():
	SettingsManager.save_config()
	if GlobalVariables.game_active:
		var pause_menu_scene = load("res://Menus/PauseMenu/pause_menu.tscn")
		var pause_menu_instance = pause_menu_scene.instantiate()
		get_parent().add_child(pause_menu_instance)
		queue_free()
	else:
		get_tree().change_scene_to_file("res://Menus/MainMenu/main_menu.tscn")


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	SettingsManager.fullscreen = toggled_on
	SettingsManager.apply_video_settings()


func _on_aspect_ratio_button_item_selected(index: int) -> void:
	SettingsManager.aspect_ratio = aspect_ratio_button.get_item_text(index)
	SettingsManager.resolution = SettingsManager.resolution_dict[SettingsManager.aspect_ratio][0]
	SettingsManager.apply_video_settings()
	update_ui()


func _on_resolution_button_item_selected(index: int) -> void:
	SettingsManager.resolution = resolution_button.get_item_text(index)
	SettingsManager.apply_video_settings()


func _on_vsync_button_toggled(toggled_on: bool) -> void:
	SettingsManager.vsync = toggled_on
	SettingsManager.apply_video_settings()


func _on_master_volume_slider_value_changed(value):
	SettingsManager.master_volume = value
	update_ui()


func _on_music_volume_slider_value_changed(value):
	SettingsManager.music_volume = value
	update_ui()


func _on_effects_volume_slider_value_changed(value):
	SettingsManager.effects_volume = value
	update_ui()


func _on_voices_volume_slider_value_changed(value):
	SettingsManager.voices_volume = value
	update_ui()


func _on_master_volume_slider_drag_ended(_value_changed):
	SettingsManager.apply_audio_settings()
	AudioManager.play_test_sfx("Master")


func _on_music_volume_slider_drag_ended(_value_changed):
	SettingsManager.apply_audio_settings()
	AudioManager.play_test_sfx("Music")


func _on_effects_volume_slider_drag_ended(_value_changed):
	SettingsManager.apply_audio_settings()
	AudioManager.play_test_sfx("Effects")


func _on_voices_volume_slider_drag_ended(_value_changed):
	SettingsManager.apply_audio_settings()
	AudioManager.play_test_sfx("Voices")
