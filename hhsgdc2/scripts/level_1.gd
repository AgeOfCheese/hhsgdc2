extends Node2D

@onready var level_manager = $LevelManager
@onready var player = $player
@onready var bounce = $level_objects/Bounce

# Called when the node enters the scene tree for the first time.
func _ready():
	level_manager.set_fade_limit(3) # Replace with function body.
	if bounce:
		bounce.connect("body_entered", _on_bounce_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bounce_area_entered(area):
	print("hello")
	player.get_child(0).bounce()
