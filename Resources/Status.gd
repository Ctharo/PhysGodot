class_name Status
extends Iterator

@export var hypercapnia: bool
@export var hypocapnia: bool
@export var hypoxia: bool
@export var hyperoxia: bool
@export var params: TissueParams

func __init__(params: TissueParams) -> void:
	self.params = params
	self.hypercapnia = false
	self.hypocapnia = false
	self.hypoxia = false
	self.hyperoxia = false

## Assigns the status of the tissue based on the gases present
func check_chemistry(gases: Gases) -> void:
	for gas: Gas in gases:
		var result: int = check(gas)
		match gas:
			GlobalTypes.Gases.CARBON_DIOXIDE:
				if result != 0:
					hypercapnia = true if result == 1 else false
					hypocapnia = !hypercapnia
				else:
					hypercapnia = false
					hypocapnia = false

			GlobalTypes.Gases.OXYGEN:
				if result != 0:
					hypoxia = true if result == -1 else false
					hyperoxia = !hypoxia
				else:
					hypoxia = false
					hyperoxia = false

## Checks the concentration of a gas in the tissue against normal ranges defined in the [TissueParams]
func check(gas: Gas) -> int:
	var result: int
	var gas_concentration: float = gas.moles/params.mass
	if gas_concentration > params.max_concentration[gas.gas_type]:
		result = 1
	elif gas_concentration < params.min_concentration[gas.type]:
		result = -1
	else:
		result = 0
	return result
	

