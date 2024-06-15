class_name Lungs
extends Organ

signal respired

@export var respiration_rate: float :
	set(value):
		if dead:
			respiration_rate = 0
		else:
			respiration_rate = max(value, 0)

var chemical_receptor: ChemicalReceptor
@export var respiration_rate_timer: float
@export var alveoli: Alveoli
@export var signal_params: SignalParams = preload("res://Resources/Params/SignalParams/LungsSignalParams.tres")

func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.LUNGS, params)
	chemical_receptor = ChemicalReceptor.new(_change_respiration_rate, signal_params)
	add_child(chemical_receptor)
	chemical_receptor.name = "Respiratory Rate Receptor"

	alveoli = Alveoli.new()
	alveoli.name = "Alveoli"
	add_child(alveoli)
	respiration_rate = 0.2

func _physics_process(delta: float) -> void:
	if dead: return
	super._physics_process(delta)
	if get_params().perform_organ_specific_task: respire(delta)
	if get_params().perform_organ_specific_task: respiration_rate_manager()

func respiration_rate_manager() -> void:
	if respiration_rate < signal_params.physiological_target_rate: # FIXME: This would be better if not hardcoded
		receive_signal(GlobalTypes.PhysioSignal.INCREASE_RATE)
	if chemical_receptor.net_signal() == 0:
		receive_signal(GlobalTypes.PhysioSignal.DECREASE_RATE)

## Organ specific task responsible for refreshing each [Gas] amount in [Alveoli]
func respire(delta: float) -> void:
	if is_zero_approx(respiration_rate):
		return
	respiration_rate_timer += delta
	if respiration_rate_timer > 1/respiration_rate:
		respiration_rate_timer = 0
		alveoli._on_respiration()

func receive_signal(direction: GlobalTypes.PhysioSignal) -> void:
	match direction:
		GlobalTypes.PhysioSignal.INCREASE_RATE:
			chemical_receptor.receive_positive_signal()
		GlobalTypes.PhysioSignal.DECREASE_RATE:
			chemical_receptor.receive_negative_signal()

func _change_respiration_rate(value: float) -> void:
	respiration_rate += value

