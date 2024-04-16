class_name Lungs
extends Organ

signal respired

@export var respiratory_rate: float
@export var respiratory_rate_timer: float
@export var alveoli: Alveoli

func _init(params: TissueParams) -> void:
	super._init(GlobalTypes.Organs.LUNGS, params)
	alveoli = Alveoli.new()
	alveoli.name = "Alveoli"
	add_child(alveoli)
	respiratory_rate = 0.2

func _physics_process(delta: float) -> void:
	if dead: return
	super._physics_process(delta)
	respire(delta)

## Resets moles of each Gas in Alveoli
func respire(delta: float) -> void:
	if respiratory_rate == 0:
		return
	respiratory_rate_timer += delta
	if respiratory_rate_timer > 1/respiratory_rate:
		respiratory_rate_timer = 0
		alveoli._on_respiration()
