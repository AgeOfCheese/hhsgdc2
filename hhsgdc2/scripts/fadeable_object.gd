extends StaticBody2D

@export var fade_speed: float = 0.5

var is_fading = false
var has_faded = false

var is_being_gazed_at = false
@onready var sprite = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal destroyed
#func start_fade():
	#if is_fading:
		#print("Hello")
		#return
	#is_fading = true
	#print("Player is fading me")
	#var tween = create_tween().set_parallel()
	#
	#tween.tween_property(sprite, "modulate:a", 0.0, 5)
	#tween.tween_property(sprite, "scale", Vector2.ZERO, 5)
	#
	#tween.tween_callback(queue_free).set_delay(5)
func gaze_entered():
	is_being_gazed_at = true
func gaze_exited():
	is_being_gazed_at = false
func _process(delta):
	if is_being_gazed_at:
		self.modulate.a -= fade_speed * delta
		
	if self.modulate.a <= 0:
		collision_shape.disabled = true
		emit_signal("destroyed")
		queue_free() 
