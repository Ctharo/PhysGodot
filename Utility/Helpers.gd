class_name Helpers
## Class containing global helper functions

## Converts a string to title case
static func to_title_case(s: String) -> String:
	# Split the string into words based on spaces
	var words: PackedStringArray = s.split(" ")

	# Capitalize the first letter of each word
	for i in range(words.size()):
		words[i] = words[i].capitalize()

	# Join the words back into a single string with spaces
	return " ".join(words)

static func as_percent(f: float, digit: int = 0) -> String:
	return "%.*f%%" % [digit, (round_to_dec(f* 100, digit))]

static func round_to_dec(num: float, digit: int = 0) -> float:
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

static func format_time(seconds: int) -> String:
	@warning_ignore("integer_division")
	var secs: int = int(seconds % 60)
	@warning_ignore("integer_division")
	var hours: int = int(secs / 3600)
	@warning_ignore("integer_division")
	var minutes: int = int(seconds / 60)
	var formatted_time: String = ""

	if hours > 0:
		formatted_time += str(hours) + "h "
	
	if minutes > 0 or hours > 0:  # This ensures that minutes are included if hours are present
		formatted_time += str(minutes) + "m "
	
	formatted_time += str(secs) + "s"
	
	return formatted_time
