class_name Iterator
extends Resource
## Iterator base class for iterating over a collection

var _collection: Array :
	set(value):
		_collection = value
		end = _collection.size()

const START: int = 0
var current: int
var end: int

const INCREMENT = 1

## Initialize the Iterator with a collection
func _init(collection: Array = []) -> void:
	_collection = collection
	current = START

## Should be able to be used like Array.any() method
func any(method: Callable) -> bool:
	for element: Object in _collection:
		if method.call(element):
			return true
	return false

## Check if the iteration should continue
func should_continue() -> bool:
	return (current < end)

## Initialize the iterator for iteration
func _iter_init(_arg: Variant) -> bool:
	current = START
	end = _collection.size()
	return should_continue()

## Get the next item in the iteration
func _iter_next(_arg: Variant) -> bool:
	current += INCREMENT
	return should_continue()

## Get the current item in the iteration
func _iter_get(_arg: Variant) -> Object:
	return _collection[current]
