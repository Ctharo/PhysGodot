class_name Heart
extends Organ

signal heart_beated

## Heart rate in beats per second - clamped between 0 and 4 (0 - 240 bpm)
@export var heart_rate: float :
	set(value):
		heart_rate = clamp(value, 0, 4) # 0 - 4 beats per second (0 - 240 bpm)

## Stroke volume in litres per beat - clamped between 0 and 0.1 L per beat, probably won't be set dynamically
const STROKE_VOLUME: float = 0.07 # 70 ml per beat

@export var heart_rate_timer: float

var chemical_receptor: ChemicalReceptor

const HEART_RATE_INCREASE_RATE_FACTOR: float = 0.001 ## Factor by which HR increases per signal
const HEART_RATE_DECREASE_RATE_FACTOR: float = 0.1 ## Factor by which HR decreases per signal
const HEART_RATE_SIGNAL_DECAY_FACTOR: float = 0.1 ## Factor by which HR signal intensity decays after buffer time
const HEART_RATE_SIGNAL_DECAY_BUFFER: float = 10 ## Time since last signal before decay starts
const HEART_RATE_SIGNAL_DECAY_INTERVAL: float = 0.25 ## Time interval between signal intensity decay

#region Heart Rate Management
var heart_rate_increase_signal_last_received: int ## Game time in milliseconds when last signal to increase HR was received
var heart_rate_increase_signal_intensity: int : ## Incremented by 1 when signal to increase HR is received
	set(value):
		heart_rate_increase_signal_intensity = max(value, 0)
var heart_rate_increase_signal_last_decayed_at: int ## Game time in milliseconds when last decrement to intensity occured
var heart_rate_decrease_signal_intensity: int : ## Incremented by 1 when signal to decrease HR is received
	set(value):
		heart_rate_decrease_signal_intensity = max(value, 0)
var heart_rate_decrease_signal_last_decayed_at: int ## Game time in milliseconds when last decrement to intensity occured
var heart_rate_decrease_signal_last_received: int ## Game time in milliseconds when last signal to decrease HR was received
#endregion

func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.HEART, params)
	chemical_receptor = ChemicalReceptor.new(change_hr, HEART_RATE_INCREASE_RATE_FACTOR, HEART_RATE_DECREASE_RATE_FACTOR)
	add_child(chemical_receptor)
	chemical_receptor.name = "Heart Rate Receptor"
	heart_rate = 1

func _physics_process(delta: float) -> void:
	if dead: return
	super._physics_process(delta)
	#if params.perform_organ_specific_task: _decay_signals()
	#if params.perform_organ_specific_task: _update_heart_rate(delta)
	if params.perform_organ_specific_task: heart_beat(delta)

func change_hr(value: float) -> void:
	heart_rate += value

## Organ specific task responsible for timing of heartbeat which in turn triggers circulation from [Body]
func heart_beat(delta: float) -> void:
	if is_zero_approx(heart_rate):
		return
	heart_rate_timer += delta
	if heart_rate_timer > 1/heart_rate:
		heart_beated.emit(STROKE_VOLUME)
		heart_rate_timer = 0

func _on_heart_rate_decrease_signal_received() -> void:
	if Time.get_ticks_msec() - heart_rate_decrease_signal_last_received > 1000:
		chemical_receptor.receive_negative_signal()

func _on_heart_rate_increase_signal_received() -> void:
	if Time.get_ticks_msec() - heart_rate_increase_signal_last_received > 1000:
		chemical_receptor.receive_positive_signal()

## Responsible for maintaining a regular beat in absence of other signals
class SinoAtrialNode:
	pass
