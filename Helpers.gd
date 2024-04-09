class_name Helpers
## Class containing global helper functions 

## Converts a string to title case
func to_title_case(s: String) -> String:
	# Split the string into words based on spaces
	var words = s.split(" ")

	# Capitalize the first letter of each word
	for i in range(words.size()):
		words[i] = words[i].capitalize()

	# Join the words back into a single string with spaces
	return " ".join(words)