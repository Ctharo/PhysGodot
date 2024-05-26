extends Node
class_name Cell
## Responsible for managing cell-level processes
##
## Not yet implemented


var receptors: Array = []
var signal_counts: Dictionary = {}  # Total count of different types of signals

# Method to add a receptor to the cell
func add_receptor(receptor: Receptor) -> void:
	receptors.append(receptor)

# Method to process incoming signals
func receive_signal(_signal: ChemicalSignal) -> void:
	receptors.sort_custom(_compare_receptors)
	for receptor: Receptor in receptors:
		if receptor.bind_signal(_signal):
			signal_counts[_signal.type] = signal_counts.get(_signal.type, 0) + 1
			break

# Comparison function for sorting receptors
func _compare_receptors(a: Receptor, b: Receptor) -> int:
	var affinity_a = 1 if a.bound_signals.size() < a.max_signals else 0
	var affinity_b = 1 if b.bound_signals.size() < b.max_signals else 0
	return affinity_b - affinity_a

# Method to update receptors and degrade signals
func update_signals() -> void:
	for receptor in receptors:
		receptor.update_signals()
		for _signal in receptor.bound_signals.keys():
			signal_counts[_signal.type] = max(0, signal_counts.get(_signal.type, 0) - 1)

# Called when the node enters the scene tree
func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 0.5  # Update signals every 0.5 seconds
	timer.timeout.connect(_on_Timer_timeout)
	add_child(timer)
	timer.start()

	var receptor1 = Receptor.new()
	var receptor2 = Receptor.new()
	add_receptor(receptor1)
	add_receptor(receptor2)

	# Create a large number of signals
	for i in range(2000):
		var _signal = ChemicalSignal.new("type1", randi() % 100 / 100.0, 5.0, 1.0)
		receive_signal(_signal)

# Timer timeout callback function
func _on_Timer_timeout() -> void:
	update_signals()
