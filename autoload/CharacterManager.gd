extends Node

@export var characters: Dictionary

var character_label_colors: Dictionary = {}

func get_character(char_name: String) -> Character:
	var character = self.characters.get(char_name).instantiate()
	self.character_label_colors[char_name] = character.character_label_color
	return character

func get_character_color(char_name:String):
	if self.character_label_colors.has(char_name):
		return self.character_label_colors[char_name]
	return Color("#ffffff")
