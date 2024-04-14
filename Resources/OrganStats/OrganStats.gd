class_name OrganStats
extends Resource

## Effects rate of [enum GlobalTypes.Gas.OXYGEN] consumption and [enum GlobalTypes.Gas.CARBON_DIOXIDE] production
@export var metabolism_factor: float

## Effects rate of gas diffusion between [Tissue] and [Vessel] (i.e., higher value increases rate of diffusion)
@export var vascularity_factor: float

## Used for concentration calculations
@export var mass: float

