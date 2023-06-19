extends Node

@export var text_sounds: Dictionary = {}

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
