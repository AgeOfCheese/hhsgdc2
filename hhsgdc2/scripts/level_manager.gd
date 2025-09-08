extends Node
@export var fade_limit: int = 10000
@onready var label = $"../Label"

#@export var next_level_scenes: Array[String] = ["res://scenes/level_1.tscn",  "res://scenes/level_2.tscn"]
#
#@export var tutorial_levels: Array[String] = ["res://scenes/prologue_level_1.tscn", "res://scenes/prologue_level_2.tscn"]

var faded_object_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var fadeable_objects = get_tree().get_nodes_in_group("fadeable")
	
	for object in fadeable_objects:
		object.get_child(0).connect("destroyed", _on_object_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if label:
		label.set_text(str(fade_limit - faded_object_count))


func _on_object_destroyed():
	print("Object destroyed")
	faded_object_count+=1
	if faded_object_count>=fade_limit:
		fail_level()

func fail_level():
	GameState._record_failure()
	


func succeed_level(is_tutorial_level: bool):
		if is_tutorial_level:
			get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")	
		else:
			get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")


func set_fade_limit(limit):
	fade_limit = limit

func _on_level_exit_body_entered(body):
	print(body.get_name())
	if body.get_name() == "CharacterBody2D":
		succeed_level(false)
	 # Replace with function body.
