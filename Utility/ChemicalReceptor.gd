class_name ChemicalReceptor
extends Node
## Responsible to receive and integrate positive and negative signals to effect change

var effector_method: Callable

var positive_signal_intensity: float
var negative_signal_intensity: float

var positive_signal_last_received_at: int
var negative_signal_last_received_at: int
var positive_signal_last_decayed_at: int
var negative_signal_last_decayed_at: int

var positive_signals: Array[int]
var negative_signals: Array[int]

# FIXME: Should be set by parent class or??
var POSITIVE_SIGNAL_EFFECT_FACTOR: float ## Factor by which positive signals influence
var NEGATIVE_SIGNAL_EFFECT_FACTOR: float ## Factor by which negative signals influence
var params: TissueParams

const POSITIVE_SIGNAL_LIFETIME: float = 10 ## Time in seconds a positive signal will last before decaying
const NEGATIVE_SIGNAL_LIFETIME: float = 10 ## Time in seconds a negative signal will last before decaying

const SIGNAL_REFRACTORY_PERIOD: float = 0.5 ## Delay between signal receiving

const SIGNAL_DECAY_FACTOR: float = 0.03 ## Factor by which signal intensity decays after buffer time
const SIGNAL_DECAY_BUFFER: float = 10 ## Time since last signal before decay starts
const SIGNAL_DECAY_INTERVAL: float = 0.25 ## Time interval between signal intensity decay

func _init(member: Callable, params: TissueParams) -> void:
	effector_method = member
	POSITIVE_SIGNAL_EFFECT_FACTOR = params.physiological_rate_increase_factor
	NEGATIVE_SIGNAL_EFFECT_FACTOR = params.physiological_rate_decrease_factor

func _physics_process(delta: float) -> void:
	signal_decay()
	effect(delta)

func effect(delta: float) -> void:
	var net: int = net_signal()
	if net == 0:
		return
	var factor: float = POSITIVE_SIGNAL_EFFECT_FACTOR if net > 0 else NEGATIVE_SIGNAL_EFFECT_FACTOR
	var value: float = float(net) * delta * factor
	effector_method.call(value)

func net_signal() -> int:
	var i: int
	i = positive_signals.size() - negative_signals.size()
	return i

func receive_positive_signal() -> void:
	var time: int = Time.get_ticks_msec()
	if time - positive_signal_last_received_at > SIGNAL_REFRACTORY_PERIOD * 1000:
		positive_signal_last_received_at = time
		positive_signals.append(time)

func receive_negative_signal() -> void:
	var time: int = Time.get_ticks_msec()
	if time - negative_signal_last_received_at > SIGNAL_REFRACTORY_PERIOD * 1000:
		negative_signal_last_received_at = time
		negative_signals.append(time)

func signal_decay() -> void:
	var time: int = Time.get_ticks_msec()
	if time - positive_signal_last_decayed_at > 1000:
		var pos_signals: Array[int] = positive_signals.duplicate()
		if not pos_signals.size():
			return
		for s in pos_signals:
			if time - s > POSITIVE_SIGNAL_LIFETIME * 1000:
				positive_signals.erase(s)
		positive_signal_last_decayed_at = time

	if time - negative_signal_last_decayed_at > 1000:
		var neg_signals: Array[int] = negative_signals.duplicate()
		if not neg_signals.size():
			return
		for s in neg_signals:
			if time - s > NEGATIVE_SIGNAL_LIFETIME * 1000:
				negative_signals.erase(s)
		negative_signal_last_decayed_at = time
