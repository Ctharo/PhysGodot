class_name ChemicalReceptor
extends Node
## Responsible to receive and integrate positive and negative signals to effect change
##
## Child of an [Organ], responsible to integrate all signals from all sources and alter some physiological
## process

var effector_method: Callable

var positive_signal_intensity: float
var negative_signal_intensity: float

var positive_signal_last_received_at: int
var negative_signal_last_received_at: int
var positive_signal_last_decayed_at: int
var negative_signal_last_decayed_at: int

var positive_signals: Array[int]
var negative_signals: Array[int]
var params: SignalParams

func _init(member: Callable, params: SignalParams) -> void:
	effector_method = member
	self.params = params
	assert(params)

func _physics_process(delta: float) -> void:
	signal_decay()
	effect(delta)

func effect(delta: float) -> void:
	var net: int = net_signal()
	if net == 0:
		return
	var factor: float = params.physiological_rate_increase_factor if net > 0 else params.physiological_rate_decrease_factor
	var value: float = float(net) * delta * factor
	effector_method.call(value)

func net_signal() -> int:
	var i: int
	i = positive_signals.size() - negative_signals.size()
	return i

func receive_positive_signal() -> void:
	var time: int = Time.get_ticks_msec()
	if time - positive_signal_last_received_at > params.signal_refractory_period * 1000:
		positive_signal_last_received_at = time
		positive_signals.append(time)

func receive_negative_signal() -> void:
	var time: int = Time.get_ticks_msec()
	if time - negative_signal_last_received_at > params.signal_refractory_period * 1000:
		negative_signal_last_received_at = time
		negative_signals.append(time)

func signal_decay() -> void:
	var time: int = Time.get_ticks_msec()
	if time - positive_signal_last_decayed_at > 1000:
		var pos_signals: Array[int] = positive_signals.duplicate()
		if not pos_signals.size():
			return
		for s in pos_signals:
			if time - s > params.positive_signal_lifetime * 1000:
				positive_signals.erase(s)
		positive_signal_last_decayed_at = time

	if time - negative_signal_last_decayed_at > 1000:
		var neg_signals: Array[int] = negative_signals.duplicate()
		if not neg_signals.size():
			return
		for s in neg_signals:
			if time - s > params.negative_signal_lifetime * 1000:
				negative_signals.erase(s)
		negative_signal_last_decayed_at = time
