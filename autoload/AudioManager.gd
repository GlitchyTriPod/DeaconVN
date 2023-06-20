extends Node

@export var text_sounds: Dictionary = {}
@export var sound_effects: Dictionary = {}
@export var music_library: Dictionary = {}

@onready var music_node : AudioStreamPlayer = %Music
@onready var sfx_node: AudioStreamPlayer = %SFX
@onready var text_sound_node: AudioStreamPlayer = %TextSound

# Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.

func load_text_noise(text_sound: String):
	# if self.text_sound_node == null:
	# 	await self.ready

	if !self.text_sounds.has(text_sound):
		return
	
	self.text_sound_node.stream = self.text_sounds.get(text_sound)

func set_text_sound_from_char_name(char_name: String):
	load_text_noise(
		get_node("/root/CharacterManager")
			.get_character_text_sound(char_name)
	)

func play_text_sound(_letter: String = "", _letter_index: int = 0, _speed: float = 0.0):
	self.text_sound_node.play()

func play_music(music_name: String, fade_in: float = 0.0):
	self.music_node.stream = self.music_library.get(music_name)
	self.music_node.volume_db = -60.0
	self.music_node.play()

	var tween = create_tween()
	tween.tween_property(
		self.music_node,
		"volume_db",
		0.0,
		fade_in
	)

func stop_music(fade_out: float = 0.0):
	var tween = create_tween()
	await tween.tween_property(
		self.music_node,
		"volume_db",
		-60.0,
		fade_out
	).finished

	self.music_node.stop()

func play_sfx(sfx_name: String):
	self.sfx_node.stream = self.sound_effects.get(sfx_name)
	self.sfx_node.play()
