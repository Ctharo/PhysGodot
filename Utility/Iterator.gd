class_name Iterator
extends Resource
## Iterator base class for iterating over a collection


## Generic container class for managing instances of type [T]
var elements: Array:
	set(value):
		elements = value as Array
		end = elements.size()
	get:
		return elements as Array

const START: int = 0
var current: int
var end: int

const INCREMENT = 1

## Initialize the Iterator with a collection
func _init(collection: Array = []) -> void:
	elements = collection
	current = START

## Should be able to be used like Array.any() method
func any(method: Callable) -> bool:
	for element: Object in elements:
		if method.call(element):
			return true
	return false

## Check if the iteration should continue
func should_continue() -> bool:
	return (current < end)

func _iter() -> Iterator:
	return Iterator.new(elements)

## Initialize the iterator for iteration
func _iter_init(_arg: Variant) -> bool:
	current = START
	end = elements.size()
	return should_continue()

## Get the next item in the iteration
func _iter_next(_arg: Variant) -> bool:
	current += INCREMENT
	return should_continue()

## Get the current item in the iteration
func _iter_get(_arg: Variant) -> Object:
	return elements[current]

func add(element: Variant) -> void:
	elements.append(element)

## Returns the count of elements
func size() -> int:
	return elements.size()

func is_empty() -> bool:
	return elements.is_empty()
