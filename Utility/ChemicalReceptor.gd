class_name ChemicalReceptor
extends Cacheable

## Responsible for receiving and integrating positive and negative signals to effect change
##
## Child of an [Organ], responsible for integrating all signals from various sources and altering some physiological
## process

## Callable method to effect change in the physiological process
var effector_method: Callable

var positive_signal_intensity: float ## Intensity of positive signals
var negative_signal_intensity: float ## Intensity of negative signals


var positive_signal_last_received_at: int ## Timestamp of the last positive signal received
var negative_signal_last_received_at: int ## Timestamp of the last negative signal received
var positive_signal_last_decayed_at: int ## Timestamp of when the last positive signal decayed
var negative_signal_last_decayed_at: int ## Timestamp of when the last negative signal decayed


var positive_signals: Array[int] ## Array to store received positive signal timestamps
var negative_signals: Array[int] ## Array to store received negative signal timestamps

## Parameters for signal handling and effecting physiological changes
var params: SignalParams

## Initializes the ChemicalReceptor with an effector method and parameters
##
## @param member: Callable method to be called to effect change
## @param params: SignalParams containing parameters for signal handling and effecting changes
func _init(member: Callable, params: SignalParams) -> void:
	effector_method = member
	self.params = params
	assert(params)

## Handles signal decay and effects the physiological change each physics frame
##
## @param delta: Time elapsed since the last frame
func _physics_process(delta: float) -> void:
	signal_decay()
	effect(delta)

## Applies the net effect of signals to the physiological process
##
## @param delta: Time elapsed since the last frame
func effect(delta: float) -> void:
	var net: int = net_signal()
	if net == 0:
		return
	var factor: float = params.physiological_rate_increase_factor if net > 0 else params.physiological_rate_decrease_factor
	var value: float = float(net) * delta * factor
	effector_method.call(value)

## Calculates the net signal from positive and negative signals
##
## @return: Net signal as an integer
func net_signal() -> int:
	var i: int
	i = positive_signals.size() - negative_signals.size()
	return i

## Receives a positive signal and records its timestamp
func receive_positive_signal() -> void:
	var time: int = Time.get_ticks_msec()
	if time - positive_signal_last_received_at > params.signal_refractory_period * 1000:
		positive_signal_last_received_at = time
		positive_signals.append(time)

## Receives a negative signal and records its timestamp
func receive_negative_signal() -> void:
	var time: int = Time.get_ticks_msec()
	if time - negative_signal_last_received_at > params.signal_refractory_period * 1000:
		negative_signal_last_received_at = time
		negative_signals.append(time)

## Handles the decay of old signals based on their lifetimes
func signal_decay() -> void:
	var time: int = Time.get_ticks_msec()
	if time - positive_signal_last_decayed_at > 1000:
		var pos_signals: Array[int] = positive_signals.duplicate()
		if pos_signals.is_empty():
			return
		for s in pos_signals:
			if time - s > params.positive_signal_lifetime * 1000:
				positive_signals.erase(s)
		positive_signal_last_decayed_at = time

	if time - negative_signal_last_decayed_at > 1000:
		var neg_signals: Array[int] = negative_signals.duplicate()
		if neg_signals.is_empty():
			return
		for s in neg_signals:
			if time - s > params.negative_signal_lifetime * 1000:
				negative_signals.erase(s)
		negative_signal_last_decayed_at = time
