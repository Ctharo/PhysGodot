extends Node
class_name Vessel

const VEIN: String = "Vein"
const CAPILLARIES: String = "Capillaries"
const ARTERY: String = "Artery"
var volume: float
var type: String

func _init(vessel_type: String, volume: float = 1.0):
	self.type = vessel_type
	self.volume = volume



