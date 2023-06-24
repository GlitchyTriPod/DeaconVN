extends Node

@onready var day_of_week: String:
	get:
		match Time.get_date_dict_from_system().weekday:
			0:
				return "Sunday"
			1:
				return "Monday"
			2:
				return "Tuesday"
			3:
				return "Wednesday"
			4:
				return "Thursday"
			5: 
				return "Friday"
			_:
				return "Saturday"

var watched_inko_apt_intro = false
var asked_inko_for_help = false

var inko_suggestions = [
	{
		"text": "Why not see what The Palette Cleansers are up to? You work as their stagehand sometimes, don't cha?",
		"read": false
	},
	{
		"text": "Maybe your sister could hook you up with somethin' at the library?",
		"read": false
	},
	{
		"text": "Cori's always lookin' for more bartenders at Kerplunk. She knows you well enough, maybe she'll give you a chance. Maybe.",
		"read": false
	},
	{
		"text": "If you're really strapped for cash, Grizzco is always open. Hell, I could help you with a shift if you want.",
		"read": false
	},
]

var inko_suggestion: String:
	get:
		return (func():
			self.inko_suggestions.shuffle()
			for i in self.inko_suggestions:
				if i.read == false:
					i.read = true
					return i.text
			return "Sorry, Dee. I'm fresh outta ideas. Maybe I'll come up with something later.").call()

func set_variable(var_name: String, value: Variant):
	self[var_name] = value
