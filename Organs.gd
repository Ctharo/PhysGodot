extends Iterator
class_name Organs
## Manages iterable list of [Organ] instances

var organs: Array[Organ] :
	set(value):
		_collection = value
	get:
		return _collection

func _iter() -> Iterator:
	return Iterator.new(organs)

func get_organ_by_name(organ_name: String):
	for organ in organs:
		if organ.name == organ_name:
			return organ
	return null
