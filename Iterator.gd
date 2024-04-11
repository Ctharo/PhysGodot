class_name Iterator
extends Resource
## Iterator base class for iterating over a collection

var _collection :
	set(value):
		_collection = value
		end = _collection.size()

const START: int = 0
var current: int
var end: int

const INCREMENT = 1

## Initialize the Iterator with a collection
func _init(collection = []):
	_collection = collection
	current = START

## Check if the iteration should continue
func should_continue():
	return (current < end)

## Initialize the iterator for iteration
func _iter_init(_arg):
	current = START
	end = _collection.size()
	return should_continue()

## Get the next item in the iteration
func _iter_next(_arg):
	current += INCREMENT
	return should_continue()

## Get the current item in the iteration
func _iter_get(_arg):
	return _collection[current]
