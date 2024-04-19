class_name Data
extends Resource
## Used to manage the methods and records related to data collection

## Holds structured dictionaries defined by internal classes
@export var d: Array[Dictionary]


enum type { RECEIVED_GAS, DELIVERED_GAS }

func delivered_gas(delivered: Delivered) -> void:
	var dict: Dictionary = {
		"by": delivered.by,
		"amount": delivered.amount,
		"time": delivered.time
	}
	d.append(dict)

## Meant to provide structure for incoming data
class Delivered:
	var by: String
	var time: float
	var amount: float


