class_name CircuitDevice
extends Node2D

const SIG_LO := 0
const SIG_HI := ~0
const SIG_UNKNOWN := 1

var config = ConfigFile.new()

var description := ""
var pin_names := []
var pin_signals := []

# r0 to r7 general-purpose registers.
var gpr := [0, 0, 0, 0, 0, 0, 0, 0]

var gnd_idx := -1
var vcc_idx := -1


func load_ini(path: String) -> void:
	config.load(path)

	# The first section contains the name of the device.
	name = config.get_sections()[0]
	
	description = config.get_value(name, "description", "")

	while true:
		var pname = config.get_value(
			name + ".pins", 
			"p" + str(len(pin_names) + 1),
		)
		if pname == null:
			break
		if pname == "VCC":
			vcc_idx = len(pin_names)
		if pname == "GND":
			gnd_idx = len(pin_names)
		pin_names.append(pname)
		pin_signals.append(SIG_UNKNOWN)

	# Number of pins must be even.
	assert(len(pin_names) % 2 == 0)


func _working() -> bool:
	return pin_signals[gnd_idx] == SIG_LO and pin_signals[vcc_idx] == SIG_HI


func process_inputs() -> void:
	if not _working():
		return
	for key in config.get_section_keys(name + ".logic"):
		var value = config.get_value(name + ".logic", key)

		var out_arr: Array
		var out_idx: int

		if key.begins_with("p"):  # pins
			out_arr = pin_signals
			out_idx = key.trim_prefix("p").to_int() - 1
		elif key.begins_with("r"):  # registers
			out_arr = gpr
			out_idx = key.trim_prefix("r").to_int()

		var value_args = value.split(" ", false)
		var operator := ""
		var operands := []
		
		for arg in value_args:
			if arg.begins_with("p"):  # pins
				operands.append(pin_signals[arg.trim_prefix("p").to_int() - 1])
			elif arg.begins_with("r"):  # registers
				operands.append(gpr[arg.trim_prefix("r").to_int()])
			elif not operator:
				operator = arg
		
		if operator == "~":
			out_arr[out_idx] = ~operands[0]
		elif operator == "&":
			out_arr[out_idx] = operands[0] & operands[1]
		elif operator == "|":
			out_arr[out_idx] = operands[0] | operands[1]
		elif operator == "^":
			out_arr[out_idx] = operands[0] ^ operands[1]
		elif operator == "~&":
			out_arr[out_idx] = ~(operands[0] & operands[1])
		elif operator == "~|":
			out_arr[out_idx] = ~(operands[0] | operands[1])
		elif operator == "~^":
			out_arr[out_idx] = ~(operands[0] ^ operands[1])

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
