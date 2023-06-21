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

func set_variable(var_name: String, value: Variant):
	self[var_name] = value
