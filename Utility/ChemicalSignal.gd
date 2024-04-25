class_name ChemicalSignal
extends Resource
## Responsible to receive and integrate positive and negative signals to effect change

var positive_signal_intensity: float
var negative_signal_intensity: float

var positive_signal_last_received_at: int
var negative_signal_last_received_at: int
var positive_signal_last_decayed_at: int
var negative_signal_last_decayed_at: int

var positive_signals: Array[int]
var negative_signals: Array[int]

const POSITIVE_SIGNAL_EFFECT_FACTOR: float = 0.001 ## Factor by which positive signals influence
const NEGATIVE_SIGNAL_EFFECT_FACTOR: float = 0.01 ## Factor by which negative signals influence
const POSITIVE_SIGNAL_LIFETIME: float = 10 ## Time in seconds a positive signal will last before decaying
const NEGATIVE_SIGNAL_LIFETIME: float = 10 ## Time in seconds a negative signal will last before decaying

const MAX_SIGNAL_RECEIVE_RATE: float = 1 ## How many times per second can a signal be received

const SIGNAL_DECAY_FACTOR: float = 0.03 ## Factor by which signal intensity decays after buffer time
const SIGNAL_DECAY_BUFFER: float = 10 ## Time since last signal before decay starts
const SIGNAL_DECAY_INTERVAL: float = 0.25 ## Time interval between signal intensity decay

func _process(delta: float) -> void:
	signal_decay()

func net_signal() -> int:
	var i: int
	i = positive_signals.size() - negative_signals.size()
	return i

func receive_positive_signal() -> void:
	positive_signals.append(Time.get_ticks_msec())

func receive_negative_signal() -> void:
	negative_signals.append(Time.get_ticks_msec())

func signal_decay() -> void:
	var time: int = Time.get_ticks_msec()

	if time - positive_signal_last_decayed_at > 1000:
		var pos_signals: Array[int] = positive_signals.duplicate()
		for s in pos_signals:
			if time - s > POSITIVE_SIGNAL_LIFETIME:
				positive_signals.erase(s)
		positive_signal_last_decayed_at = time

	if time - negative_signal_last_decayed_at > 1000:
		var neg_signals: Array[int] = negative_signals.duplicate()
		for s in neg_signals:
			if time - s > NEGATIVE_SIGNAL_LIFETIME:
				negative_signals.erase(s)
		negative_signal_last_decayed_at = time
