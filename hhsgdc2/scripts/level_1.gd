extends Node2D

@onready var level_manager = $LevelManager

# Called when the node enters the scene tree for the first time.
func _ready():
	level_manager.set_fade_limit(3) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
