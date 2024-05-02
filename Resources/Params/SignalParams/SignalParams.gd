class_name SignalParams
extends Resource
## Provides values from which a Signal Receptor can derive functionality

## Factor by which the [Organ]'s physiological function increases
@export var physiological_rate_increase_factor: float

## Factor by which the [Organ]'s physiological function decreases
@export var physiological_rate_decrease_factor: float


@export var positive_signal_lifetime: float = 10 ## Time in seconds a positive signal will last before decaying
@export var negative_signal_lifetime: float = 10 ## Time in seconds a negative signal will last before decaying

@export var signal_refractory_period: float = 0.5 ## Delay between signal receiving

@export var signal_decay_factor: float = 0.03 ## Factor by which signal intensity decays after buffer time
@export var signal_decay_buffer: float = 10 ## Time since last signal before decay starts
@export var signal_decay_interval: float = 0.25 ## Time interval between signal intensity decay
