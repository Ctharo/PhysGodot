extends Cacheable
class_name Receptor

var bound_signals: Dictionary = {}  # Stores signals and their binding times
var max_signals: int = 1000  # Maximum number of signals that can bind at once
var signal_queue: Array = []

var effector_method: Callable

var positive_signal_intensity: float
var negative_signal_intensity: float

var positive_signals: Array[Dictionary]  # Store received positive signals with timestamps and properties
var negative_signals: Array[Dictionary]  # Store received negative signals with timestamps and properties

var params: SignalParams

func _init(member: Callable, params: SignalParams) -> void:
	effector_method = member
	self.params = params
	assert(params)
	positive_signals = []
	negative_signals = []

func _physics_process(delta: float) -> void:
	signal_decay()
	update_signals(delta)
	effect(delta)

func effect(delta: float) -> void:
	var net = get_cached_value("net_signal", self.calculate_net_signal)
	if net == 0:
		return
	var factor = params.physiological_rate_increase_factor if net > 0 else params.physiological_rate_decrease_factor
	var value = float(net) * delta * factor
	effector_method.call(value)

func calculate_net_signal() -> int:
	return positive_signals.size() - negative_signals.size()

func bind_signal(_signal: Dictionary) -> bool:
	if bound_signals.size() < max_signals:
		bound_signals[_signal] = Time.get_ticks_msec()
		return true
	else:
		signal_queue.append(_signal)
		return false

func receive_positive_signal(_signal: Dictionary) -> void:
	var time = Time.get_ticks_msec()
	if time - (positive_signals[-1].get('timestamp', 0) if positive_signals.size() > 0 else 0) > params.signal_refractory_period * 1000:
		_signal['timestamp'] = time
		positive_signals.append(_signal)
		bind_signal(_signal)
		invalidate_cache("net_signal")

func receive_negative_signal(_signal: Dictionary) -> void:
	var time = Time.get_ticks_msec()
	if time - (negative_signals[-1].get('timestamp', 0) if negative_signals.size() > 0 else 0) > params.signal_refractory_period * 1000:
		_signal['timestamp'] = time
		negative_signals.append(_signal)
		bind_signal(_signal)
		invalidate_cache("net_signal")

func signal_decay() -> void:
	var time = Time.get_ticks_msec()
	var to_remove = []
	for _signal: Dictionary in bound_signals.keys():
		var binding_time = bound_signals[_signal]
		var elapsed_time = (time - binding_time) / 1000.0
		_signal.effect *= pow(0.5, elapsed_time / _signal.half_life)
		if _signal.effect < 0.01:
			to_remove.append(_signal)
	for _signal in to_remove:
		bound_signals.erase(_signal)
		invalidate_cache("net_signal")

	while bound_signals.size() < max_signals and signal_queue.size() > 0:
		var signal_to_bind = signal_queue.pop_front()
		bound_signals[signal_to_bind] = Time.get_ticks_msec()
		invalidate_cache("net_signal")

func update_signals(delta: float) -> void:
	var current_time = Time.get_ticks_msec()
	for _signal in bound_signals.keys():
		var binding_time = bound_signals[_signal]
		var elapsed_time = (current_time - binding_time) / 1000.0
		_signal.effect *= pow(0.5, elapsed_time / _signal.half_life)
		if _signal.effect < 0.01:
			bound_signals.erase(_signal)
			invalidate_cache("net_signal")
	
	# Process queued signals
	while bound_signals.size() < max_signals and signal_queue.size() > 0:
		var signal_to_bind = signal_queue.pop_front()
		bound_signals[signal_to_bind] = Time.get_ticks_msec()
		invalidate_cache("net_signal")
