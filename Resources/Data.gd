class_name Data
extends Resource
## Used to manage the methods and records related to data collection

## Holds structured dictionaries defined by internal classes
@export var d: Array[Dictionary]
## Holds structured dictionaries defined by internal classes
@export var r: Array[Dictionary]
var parent: Node

enum type { RECEIVED_GAS, DELIVERED_GAS }

func _init(tissue: Tissue) -> void:
	parent = tissue

func delivered_gas(delivered: Delivered) -> void:
	if delivered.amount == 0:
		return
	var dict: Dictionary = {
		"to": delivered.to,
		"amount": delivered.amount,
		"time": delivered.time
	}
	d.append(dict)

func received_gas(received: Received) -> void:
	if received.amount == 0:
		return
	var dict: Dictionary = {
		"from": received.from,
		"amount": received.amount,
		"time": received.time
	}
	r.append(dict)

## Meant to provide structure for incoming data
class Delivered:
	var to: String
	var time: float
	var amount: float

class Received:
	var from: String
	var time: float
	var amount: float

