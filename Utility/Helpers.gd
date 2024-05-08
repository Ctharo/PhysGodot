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

## Returns a string of the elapsed time from provided milliseconds (msecs) argument
static func format_time(msecs: int) -> String:
	@warning_ignore("integer_division")
	var hours: int = msecs / 1000 / 3600
	@warning_ignore("integer_division")
	var minutes: int = (msecs / 1000 / 60) % 60  # Use modulo to get the remainder minutes
	@warning_ignore("integer_division")
	var secs: int = (msecs / 1000) % 60  # Use modulo to get the remainder seconds
	var formatted_time: String = ""

	if hours > 0:
		formatted_time += str(hours) + "h "
	
	if minutes > 0 or hours > 0:  # This ensures that minutes are included if hours are present
		formatted_time += str(minutes) + "m "
	
	formatted_time += str(secs) + "s"
	
	return formatted_time

