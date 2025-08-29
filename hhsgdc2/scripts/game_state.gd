extends Node

var madness_level: float = 0.0
const MADNESS_PER_FAILURE: float = 0.1

func _record_failure():
	madness_level = min(madness_level + MADNESS_PER_FAILURE,1.0)
	print("Player failed. Madness is now: ", madness_level)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
