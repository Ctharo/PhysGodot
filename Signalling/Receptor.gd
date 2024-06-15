extends Node
class_name Receptor

var bound_signals: Dictionary = {}  # Stores signals and their binding times
var max_signals: int = 1000  # Maximum number of signals that can bind at once
var signal_queue: Array = []

# Method to bind a signal
func bind_signal(_signal: ChemicalSignal) -> bool:
	if bound_signals.size() < max_signals:
		bound_signals[_signal] = Time.get_ticks_msec()
		return true
	else:
		signal_queue.append(_signal)
		return false

# Method to update and degrade bound signals
func update_signals() -> void:
	var current_time = Time.get_ticks_msec()
	for _signal: ChemicalSignal in bound_signals.keys():
		var binding_time = bound_signals[_signal]
		var elapsed_time = (current_time - binding_time) / 1000.0
		_signal.effect *= pow(0.5, elapsed_time / _signal.half_life)
		if _signal.effect < 0.01:
			bound_signals.erase(_signal)

	# Process queued signals
	while bound_signals.size() < max_signals and signal_queue.size() > 0:
		var signal_to_bind = signal_queue.pop_front()
		bound_signals[signal_to_bind] = Time.get_ticks_msec()
