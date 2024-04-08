extends Iterator
class_name Organs
## Manages iterable list of [Organ] instances

var organs: Array[Organ]


func _init(organs: Array[Organ] = []):
	# Call parent constructor
	super._init(organs)
	self.organs = organs
	

func _iter() -> Iterator:
	return Iterator.new(organs)

func add_organ(organ: Organ) -> void:
	organs.append(organ)
	collection = organs

func get_organ_by_name(organ_name: String):
	for organ in organs:
		if organ.name == organ_name:
			return organ
	return null
