extends Node
class_name Cacheable

## Provides caching capability for classes with calculation-dependent members
##
## Expect derived Node to provide static methods for forced calculations for cacheable values

var cache: Dictionary = {}
var cache_timestamps: Dictionary = {}
var cache_last_calculation: Dictionary = {}

const CHECK_EXPIRED_DURATION: float = 1.0
const MIN_UPDATE_INTERVAL: int = 100  # Minimum interval in milliseconds (approximately one frame at 60 FPS)

## Method to get a cached value or calculate it if not present. Calculator Callable should not rely on a potentially cached value
<<<<<<< Updated upstream
## (i.e., only static *.calculate_ methods should be passed).
func get_cached_value(key: String, calculator: Callable, force_update: bool = false, duration: float = -1) -> Variant:
=======
##[br](i.e., only static *.calculate_ methods should be passed).
func get_cached_value(key: String, calculator: Callable, duration: float = -1) -> Variant:
>>>>>>> Stashed changes
	var current_time: int = Time.get_ticks_msec()

	# Check if the value is cached and not expired
	if cache.has(key):
		if cache_timestamps.has(key):
			if cache_timestamps[key] > current_time:
<<<<<<< Updated upstream
				# If force_update is true, check if it was recently updated
				if force_update:
					if is_recently_updated(key):
						return cache[key]
				else:
					return cache[key]
		else:
			# No timestamp means it does not expire
			if force_update:
				if is_recently_updated(key):
					return cache[key]
			else:
				return cache[key]

	# Calculate the value if not cached, expired, or forced update
	@warning_ignore("untyped_declaration")
	var value = calculator.call()
	cache[key] = value
	cache_last_calculation[key] = current_time
=======
				return cache[key]
		else:
			return cache[key]

	# Calculate the value if not cached or expired
	@warning_ignore("untyped_declaration")
	var value = calculator.call()
	cache[key] = value
>>>>>>> Stashed changes

	# If a duration is provided, set up the timestamp
	if duration > 0:
		cache_timestamps[key] = current_time + int(duration * 1000)
		ensure_update_timer()
	else:
		cache_timestamps.erase(key)  # Ensure no timestamp is left if duration is negative

	return value

# Method to invalidate the cache
func invalidate_cache(key: String) -> void:
	cache.erase(key)
	cache_timestamps.erase(key)
	cache_last_calculation.erase(key)

# Method to invalidate all cache
func invalidate_all_cache() -> void:
	cache.clear()
	cache_timestamps.clear()
	cache_last_calculation.clear()

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

<<<<<<< Updated upstream
	for key: String in cache_timestamps.keys():
		if cache_timestamps[key] <= current_time:
			keys_to_remove.append(key)

	for key: String in keys_to_remove:
=======
	for key:String in cache_timestamps.keys():
		if cache_timestamps[key] <= current_time:
			keys_to_remove.append(key)

	for key:String in keys_to_remove:
>>>>>>> Stashed changes
		invalidate_cache(key)

	# Stop the timer if no timestamps are left
	if cache_timestamps.is_empty():
		get_node("_cache_update_timer").stop()

# Method to check if a cache entry was recently updated within the MIN_UPDATE_INTERVAL
func is_recently_updated(key: String) -> bool:
	if not cache_last_calculation.has(key):
		return false
	var current_time: int = Time.get_ticks_msec()
	return (current_time - cache_last_calculation[key]) < MIN_UPDATE_INTERVAL
