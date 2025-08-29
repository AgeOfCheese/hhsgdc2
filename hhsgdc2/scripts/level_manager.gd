extends Node
@export var fade_limit: int = 5

@export var next_level_scenes: Array[String] = ["res://scenes/level_1.tscn",  "res://scenes/level_2.tscn"]

@export var tutorial_levels: Array[String] = ["res://scenes/prologue_level_1.tscn", "res://scenes/prologue_level_2.tscn"]

var faded_object_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var fadeable_objects = get_tree().get_nodes_in_group("fadeable")
	
	for object in fadeable_objects:
		object.get_child(0).connect("destroyed", _on_object_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_object_destroyed():
	print("Object destroyed")
	faded_object_count+=1
	if faded_object_count>=fade_limit:
		fail_level()

func fail_level():
	GameState._record_failure()
	
	var next_scene_path = next_level_scenes.pick_random()
	get_tree().change_scene_to_file(next_scene_path)	
	
func succeed_level(is_tutorial_level: bool, current: int):
		if is_tutorial_level:
			var next_scene_path = tutorial_levels[current+1]
			get_tree().change_scene_to_file(next_scene_path)	
