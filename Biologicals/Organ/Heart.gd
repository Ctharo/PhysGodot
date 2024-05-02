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

func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.HEART, params)
	var s_params: SignalParams = load("res://Resources/Params/SignalParams/HeartSignalParams.tres")
	chemical_receptor = ChemicalReceptor.new(change_hr, s_params)
	add_child(chemical_receptor)
	chemical_receptor.name = "Heart Rate Receptor"
	heart_rate = 1

func _physics_process(delta: float) -> void:
	if dead: return
	super._physics_process(delta)
	if params.perform_organ_specific_task: heart_beat(delta)
	if params.perform_organ_specific_task: heart_rate_manager()

func heart_rate_manager() -> void:
	if heart_rate < 0.5: # FIXME: This would be better if not hardcoded
		receive_signal(GlobalTypes.PhysioSignal.INCREASE_RATE)
	if chemical_receptor.net_signal() == 0:
		receive_signal(GlobalTypes.PhysioSignal.DECREASE_RATE)

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

## Receives and propogates signal accordingly
func receive_signal(direction: GlobalTypes.PhysioSignal) -> void:
	match direction:
		GlobalTypes.PhysioSignal.INCREASE_RATE:
			chemical_receptor.receive_positive_signal()
		GlobalTypes.PhysioSignal.DECREASE_RATE:
			chemical_receptor.receive_negative_signal()
