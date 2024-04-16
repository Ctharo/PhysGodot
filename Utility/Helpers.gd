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

