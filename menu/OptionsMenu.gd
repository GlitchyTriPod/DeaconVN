extends CanvasLayer

signal fully_ready

# @onready var color = %color
@onready var control = %Control
@onready var master_slider: Slider = %MasterSlider
@onready var music_slider: Slider = %MusicSlider
@onready var sfx_slider: Slider = %SFXSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("testimg").visible = false

	# get audio bus settings
	var master_vol := AudioServer.get_bus_volume_db(0)
	var music_vol := AudioServer.get_bus_volume_db(1)
	var sfx_vol := AudioServer.get_bus_volume_db(2)

	# adjust slider
	update_sliders(master_vol, music_vol, sfx_vol)

	# assume that screen is invisible on spawn
	var tween2 = create_tween()
	await tween2.tween_property( \
		self.control, \
		"modulate", \
		Color("#ffffffff"), \
		0.5 \
	).finished

	emit_signal("fully_ready")

func update_sliders(master_vol: float, music_vol: float, sfx_vol: float):
	# interpolate value of volume from db (-60 - 0) to slider value (0 - 100) 
	var interp := func(val: float):
		return ceilf(inverse_lerp(-40.0, 0.0,val) * 100.0)

	master_vol = interp.call(master_vol)
	music_vol = interp.call(music_vol)
	sfx_vol = interp.call(sfx_vol)

	self.master_slider.value = master_vol
	%Master/Label.text = str(master_vol) + "%"
	self.music_slider.value = music_vol
	%Music/Label.text = str(music_vol) + "%"
	self.sfx_slider.value = sfx_vol
	%SFX/Label.text = str(sfx_vol) + "%"

func _on_back_button_up():
	get_node("/root/AudioManager").play_sfx("selectblip2")
	var tween2 = create_tween()
	await tween2.tween_property( \
		self.control, \
		"modulate", \
		Color("#ffffff00"), \
		0.5 \
	).finished

	self.queue_free()

func _on_master_slider_value_changed(value: float):
	if value == 0.0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, lerp(-40.0, 0.0, value * 0.01))
	%Master/Label.text = str(ceilf(value)) + "%"

func _on_music_slider_value_changed(value: float):
	if value == 0.0:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		AudioServer.set_bus_volume_db(1, lerp(-40.0, 0.0, value * 0.01))
	%Music/Label.text = str(ceilf(value)) + "%"

func _on_sfx_slider_drag_ended(value_changed:bool):
	if !value_changed: return
	var value = self.sfx_slider.value
	if value == 0.0:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		AudioServer.set_bus_volume_db(2, lerp(-40.0, 0.0, value * 0.01))
	get_node("/root/AudioManager").play_sfx("selectblip2")

func _on_sfx_slider_value_changed(value:float):
	%SFX/Label.text = str(ceilf(value)) + "%"
