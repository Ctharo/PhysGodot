class_name ElementContainer
extends Iterator

## Generic container class for managing instances of type [T]
var elements: Array:
	set(value):
		_collection = value as Array
	get:
		return _collection as Array

func _iter() -> Iterator:
	return Iterator.new(elements)

func add(element: Variant) -> void:
	elements.append(element)

## Returns the count of elements
func size() -> int:
	return elements.size()

func is_empty() -> bool:
	return elements.size() == 0
