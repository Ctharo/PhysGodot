extends Node
class_name Cacheable
## Provides caching capability for classes with calculation-dependent members
##
##

var cache: Dictionary = {}
var cache_timestamps: Dictionary = {}

const CHECK_EXPIRED_DURATION: float = 1.0

## Method to get a cached value or calculate it if not present. Calculator Callable should not rely on a potentially cached value 
##[br](i.e., only static *.calculate_ methods should be passed).
func get_cached_value(key: String, calculator: Callable, duration: float = -1) -> Variant:
	if cache.has(key):
		return cache[key]
	@warning_ignore("untyped_declaration")
	var value = calculator.call()
	cache[key] = value
	
	# If a duration is provided, set up the timestamp
	if duration > 0:
		cache_timestamps[key] = Time.get_ticks_msec() + int(duration * 1000)
		ensure_update_timer()
	return value

# Method to invalidate the cache
func invalidate_cache(key: String) -> void:
	cache.erase(key)
	cache_timestamps.erase(key)

# Method to invalidate all cache
func invalidate_all_cache() -> void:
	cache.clear()
	cache_timestamps.clear()

# Method to check if a cache entry is dirty
func is_dirty(key: String) -> bool:
	return not cache.has(key)

# Method to ensure the update timer exists and is running
func ensure_update_timer() -> void:
	if not has_node("_cache_update_timer"):
		var timer: Timer = Timer.new()
		timer.name = "_cache_update_timer"
		timer.wait_time = CHECK_EXPIRED_DURATION
		timer.autostart = true
		timer.timeout.connect(_on_update_timer_timeout)
		add_child(timer)

# Timer callback method to check and invalidate expired cache entries
func _on_update_timer_timeout() -> void:
	var current_time: int = Time.get_ticks_msec()
	var keys_to_remove: Array = []
	
	for key:String in cache_timestamps.keys():
		if cache_timestamps[key] <= current_time:
			keys_to_remove.append(key)
	
	for key:String in keys_to_remove:
		invalidate_cache(key)
	
	# Stop the timer if no timestamps are left
	if cache_timestamps.is_empty():
		get_node("_cache_update_timer").stop()
