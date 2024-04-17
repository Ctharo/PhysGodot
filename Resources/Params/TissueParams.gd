class_name TissueParams
extends Resource

## Effects rate of [enum GlobalTypes.Gas.OXYGEN] consumption and [enum GlobalTypes.Gas.CARBON_DIOXIDE] production
@export var metabolism_factor: float = 1

## Effects rate of [enum GlobalTypes.Gas.OXYGEN] consumption
@export var oxygen_consumption_factor: float = 1

## Contains the minimum concentration for each [enum GlobalTypes.Gas] that the [Tissue] can tolerate
@export var min_concentration: Dictionary = {
    GlobalTypes.Gases.OXYGEN: 0.12,
    GlobalTypes.Gases.CARBON_DIOXIDE: 0.00,
}

## Contains the maximum concentration for each [enum GlobalTypes.Gas] that the [Tissue] can tolerate
@export var max_concentration: Dictionary = {
    GlobalTypes.Gases.OXYGEN: 0.22,
    GlobalTypes.Gases.CARBON_DIOXIDE: 0.08,
}

## Lower limit of what is considered hypercapneic
@export var min_o2_concentration: float = 0.12

## Effects rate of [enum GlobalTypes.Gas.CARBON_DIOXIDE] production
@export var carbon_dioxide_production_factor: float = 1

## Upper limit of what is considered hypercapneic
@export var max_co2_concentration: float = 0.08

## Effects how sensitive the [Organ] is with regards to losing health from lack of [enum GlobalTypes.Gas.OXYGEN] [br]
##(i.e., the rate of health lost during hypoxic status)
@export var hypoxia_sensitivity: float = 1

## Effects how sensitive the [Organ] is with regards to losing health from accumulation of [enum GlobalTypes.Gas.CARBON_DIOXIDE] [br]
##(i.e., the rate of health lost during hypernapneic status)
@export var hypercapnea_sensitivity: float = 1

## Effects rate of gas diffusion between [Tissue] and [Vessel] (i.e., higher value increases rate of diffusion)
@export var vascularity_factor: float = 1

## Used for concentration calculations
@export var mass: float = 1

## Sets number of child [Tissue] instances
@export var tissue_count: int = 1

## General factor affecting rate at which health is lost
@export var health_loss_factor: float = 1.0

## Turns on/off the unique role of the [Organ] (depends on [Organ])
@export var perform_organ_specific_task: bool = true

## Amount of [Blood] that can be contained within all [Vessel]s in the [Tissues]
@export var blood_volume: float = 1.0

