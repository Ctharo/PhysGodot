extends GutTest

# Variables
var params: TissueParams
var organ: Organ

@warning_ignore("untyped_declaration")
func before_all():
	# Loading from TissueParams.tres means values are at default
	params = load("res://Resources/Params/TissueParams/TissueParams.tres") as TissueParams
	
	# Adjusting values as needed
	params.tissue_count = 3
	gut.p("ran run setup", 2)

@warning_ignore("untyped_declaration")
func after_all():
	gut.p("ran run teardown", 2)

@warning_ignore("untyped_declaration")
func before_each():
	# Create a new organ for each test
	organ = Organ.new(GlobalTypes.Organs.HEART, params)
	gut.p("ran setup", 2)

@warning_ignore("untyped_declaration")
func after_each():
	gut.p("ran teardown", 2)

# Test organ initialization
@warning_ignore("untyped_declaration")
func test_organ_initialization():
	assert_eq(organ.type, GlobalTypes.Organs.HEART, "Organ type should be HEART")
	assert_eq(organ.params, params, "Organ params should be equal to the initialized params")
	assert_eq(organ.name, "Heart", "Organ name should be 'Heart'")
	assert_eq(organ.tissues.size(), params.tissue_count, "Tissues count should match tissue_count in params")

# Test health calculation
@warning_ignore("untyped_declaration")
func test_health_calculation():
	var i: int = 0
	var health_values = [0.5, 0.7, 0.9]
	for tissue: Tissue in organ.tissues:
		tissue.health = health_values[i]
		i += 1
	assert_almost_eq(organ.health, 0.7, 1e-10, "Health should be the mean of all tissue health values")

# Test hypoxia detection
@warning_ignore("untyped_declaration")
func test_hypoxia_detection():
	organ.set_concentration(GlobalTypes.Gases.OXYGEN, params.min_concentration[GlobalTypes.Gases.OXYGEN] * 0.9)
	assert_true(organ.is_hypoxic(), "Organ should be hypoxic if mean O2 concentration is below min_concentration")

# Test hypercapnia detection
@warning_ignore("untyped_declaration")
func test_hypercapnia_detection():
	organ.set_concentration(GlobalTypes.Gases.CARBON_DIOXIDE, params.max_concentration[GlobalTypes.Gases.CARBON_DIOXIDE] * 1.1)
	assert_true(organ.is_hypercapnic(), "Organ should be hypercapnic if mean CO2 concentration is above max_concentration")

# Test organ death detection
@warning_ignore("untyped_declaration")
func test_organ_death():
	watch_signals(organ)
	organ.set_health(0.0)
	organ.check_health()
	assert_signal_emitted(organ, "organ_died", "Organ should emit a signal indicating it has died")
	assert_true(organ.dead, "Organ should be dead if all tissue health values are zero")
