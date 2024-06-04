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

## Returns the count of elements
func get_count() -> int:
	return elements.size()

## Static method to retrieve a String name of an element type
static func get_string(element_type: int, types_dict: Dictionary) -> String:
	return types_dict.keys()[element_type]

## Compares element types
static func is_of_type(element, type: int, type_property: String) -> bool:
	return element.get(type_property) == type
