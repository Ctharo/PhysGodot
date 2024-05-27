extends Node


# Dictionary to store the count of method calls
var call_counts: Dictionary = {}


# Method to increment the call count for a given method
func increment_call_count(method_name: String) -> void:
	if not call_counts.has(method_name):
		call_counts[method_name] = 0
	call_counts[method_name] += 1

# Method to get the call count for a given method
func get_call_count(method_name: String) -> int:
	if call_counts.has(method_name):
		return call_counts[method_name]
	return 0

# Method to reset the call count for a given method
func reset_call_count(method_name: String) -> void:
	call_counts[method_name] = 0

# Method to reset all call counts
func reset_all_call_counts() -> void:
	call_counts.clear()

# Method to get a summary of all call counts
func get_summary() -> Dictionary:
	return call_counts.duplicate()
