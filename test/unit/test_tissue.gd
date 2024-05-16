extends GutTest

# Constants
const Organ = preload("res://Biologicals/Organ/Organ.gd")
const TissueParams = preload("res://Resources/Params/TissueParams/TissueParams.gd")


# Variables
var tissue: Tissue
var params: TissueParams
var organ: Organ

func before_all():
	params = load("res://Resources/Params/TissueParams/TissueParams.tres")
	# Set all params to default values for the tests
	params.tissue_count = 3
	params.mass = 9.0
	params.blood_volume = 3.0
	params.metabolism_factor = 1.0
	params.min_concentration = { GlobalTypes.Gases.OXYGEN: 0.2 }
	params.max_concentration = { GlobalTypes.Gases.CARBON_DIOXIDE: 0.3 }
	tissue = Tissue.new(params)
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func before_each():
	# Create a new organ for each test
	organ = Organ.new(GlobalTypes.Organs.HEART, params)
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

# Test organ initialization
func test_organ_initialization():
	assert_eq(organ.type, GlobalTypes.Organs.HEART, "Organ type should be HEART")
	assert_eq(organ.params, params, "Organ params should be equal to the initialized params")
	assert_eq(organ.name, "Heart", "Organ name should be 'Heart'")
	assert_eq(organ.tissues.size(), params.tissue_count, "Tissues count should match tissue_count in params")

# Test health calculation
func test_health_calculation():
	var health_values = [0.5, 0.7, 0.9]
	for i in range(health_values.size()):
		organ.tissues[i].health = health_values[i]
	organ.check_health()
	assert_eq(organ.health, 0.7, "Health should be the mean of all tissue health values")

# Test hypoxia detection
func test_hypoxia_detection():
	organ.tissues[0].concentration[GlobalTypes.Gases.OXYGEN] = 0.1
	organ.tissues[1].concentration[GlobalTypes.Gases.OXYGEN] = 0.15
	organ.tissues[2].concentration[GlobalTypes.Gases.OXYGEN] = 0.25
	assert_true(organ.is_hypoxic(), "Organ should be hypoxic if mean O2 concentration is below min_concentration")

# Test hypercapnia detection
func test_hypercapnia_detection():
	organ.tissues[0].concentration[GlobalTypes.Gases.CARBON_DIOXIDE] = 0.35
	organ.tissues[1].concentration[GlobalTypes.Gases.CARBON_DIOXIDE] = 0.25
	organ.tissues[2].concentration[GlobalTypes.Gases.CARBON_DIOXIDE] = 0.28
	assert_true(organ.is_hypercapnic(), "Organ should be hypercapnic if mean CO2 concentration is above max_concentration")

# Test organ death detection
func test_organ_death():
	for i in range(organ.tissues.size()):
		organ.tissues[i].health = 0.0
	organ.check_health()
	assert_true(organ.dead, "Organ should be dead if all tissue health values are zero")
	assert_signal_emitted(organ, "organ_died", "Organ death signal should be emitted when organ dies")

# Register tests
func register_tests():
	add_test("test_organ_initialization", test_organ_initialization)
	add_test("test_health_calculation", test_health_calculation)
	add_test("test_hypoxia_detection", test_hypoxia_detection)
	add_test("test_hypercapnia_detection", test_hypercapnia_detection)
	add_test("test_organ_death", test_organ_death)

