extends Iterator
class_name Organs
## Manages iterable list of [Organ] instances


var organs: Array[Organ]




func _iter() -> Iterator:
	return Iterator.new(organs)

