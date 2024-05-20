class_name Heart
extends Organ

signal heart_beated

## Heart rate in beats per second - clamped between 0 and 4 (0 - 240 bpm)
@export var heart_rate: float :
	set(value):
		if dead:
			heart_rate = 0
		else:
			heart_rate = clamp(value, 0, 4) # 0 - 4 beats per second (0 - 240 bpm)

## Stroke volume in litres per beat - clamped between 0 and 0.1 L per beat, probably won't be set dynamically
const STROKE_VOLUME: float = 0.07 # 70 ml per beat
const TIME_TO_FILL_CHAMBERS: float = 0.5 # Time in seconds required for full filling of chamber before ejection

@export var heart_rate_timer: float

var chemical_receptor: ChemicalReceptor
@export var signal_params: SignalParams = preload("res://Resources/Params/SignalParams/HeartSignalParams.tres")

func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.HEART, params)
	chemical_receptor = ChemicalReceptor.new(change_hr, signal_params)
	add_child(chemical_receptor)
	chemical_receptor.name = "Heart Rate Receptor"
	heart_rate = 1

func _physics_process(delta: float) -> void:
	if dead: return
	super._physics_process(delta)
	if params.perform_organ_specific_task: heart_beat(delta)
	if params.perform_organ_specific_task: heart_rate_manager()

func heart_rate_manager() -> void:
	if heart_rate < signal_params.physiological_target_rate: # FIXME: This would be better if not hardcoded
		receive_signal(GlobalTypes.PhysioSignal.INCREASE_RATE)
	#if heart_rate > signal_params.physiological_target_rate:
		#receive_signal(GlobalTypes.PhysioSignal.DECREASE_RATE)

func change_hr(value: float) -> void:
	heart_rate += value

## Organ specific task responsible for timing of heartbeat which in turn triggers circulation from [Body]
func heart_beat(delta: float) -> void:
	if is_zero_approx(heart_rate):
		return
	heart_rate_timer += delta
	if heart_rate_timer > 1/heart_rate:
		heart_beated.emit(STROKE_VOLUME * chamber_refill(heart_rate_timer))
		heart_rate_timer = 0

## Receives and propogates signal to [member chemical_receptor]: [ChemicalReceptor]
func receive_signal(direction: GlobalTypes.PhysioSignal) -> void:
	match direction:
		GlobalTypes.PhysioSignal.INCREASE_RATE:
			chemical_receptor.receive_positive_signal()
		GlobalTypes.PhysioSignal.DECREASE_RATE:
			chemical_receptor.receive_negative_signal()

## TODO: Should occur between beats, and if HR is too fast then it will be incomplete and affect... SV?
func chamber_refill(time_to_refill: float) -> float:
	var fraction_filled: float = min(1.0, time_to_refill/TIME_TO_FILL_CHAMBERS)
	return fraction_filled
