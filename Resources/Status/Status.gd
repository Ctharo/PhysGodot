class_name Status
extends Resource

# FIXME: Meant to be a child of an [Organ] or maybe [Tissue] class to handle updating the gas-related status
# such as marking as hypoxic

@export var hypercapnia: bool
@export var hypocapnia: bool
@export var hypoxia: bool
@export var hyperoxia: bool
@export var params: TissueParams

func _init(params: TissueParams) -> void:
	self.params = params

## Assigns the status of the tissue based on the gases present
func check_chemistry(gases: Gases) -> void:
	for gas: Gas in gases:
		var result: int = check(gas)
		match gas.gas_type:
			GlobalTypes.Gases.CARBON_DIOXIDE:
				if result != 0:
					self.hypercapnia = true if result == 1 else false
					self.hypocapnia = !hypercapnia
				else:
					self.hypercapnia = false
					self.hypocapnia = false

			GlobalTypes.Gases.OXYGEN:
				if result != 0:
					self.hypoxia = true if result == -1 else false
					self.hyperoxia = !hypoxia
				else:
					self.hypoxia = false
					self.hyperoxia = false

## Checks the concentration of a gas in the tissue against normal ranges defined in the [TissueParams]
func check(gas: Gas) -> int:
	var result: int
	var gas_concentration: float = gas.moles/self.params.mass
	if gas_concentration > self.params.max_concentration[gas.gas_type]:
		result = 1
	elif gas_concentration < self.params.min_concentration[gas.gas_type]:
		result = -1
	else:
		result = 0
	return result
	
