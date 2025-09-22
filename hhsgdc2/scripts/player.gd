extends CharacterBody2D

const RAY_LENGTH: float = 10000.0
const SPEED = 300.0
const JUMP_VELOCITY = -400
const JUMP_INCREMENT = -35

var fading_object = null
var eyes_are_open = true
var pupil_center
var is_moving = false
var is_jump_charging = false


@onready var raycast = $player_sprite/pupil_sprite/GazeRay
@onready var aura = $Aura
@onready var pupil = $player_sprite/pupil_sprite
@onready var gaze_light = $player_sprite/pupil_sprite/GazeLight
@onready var sprite = $player_sprite

func _ready():
	if pupil:
		pupil_center = pupil.position
		
func _physics_process(delta):
	# Add the gravity.
	if !eyes_are_open:
		raycast.enabled = false
		gaze_light.enabled = false
		aura.enabled = false
	else:
		raycast.enabled = true
		gaze_light.enabled = true
		aura.enabled = true
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_moving:
		if velocity.x > 0:
			sprite.play("walk")
			sprite.flip_h = false
		elif velocity.x <0:
			sprite.play("walk")
			sprite.flip_h = true

	else:
		sprite.play("idle")
		
	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		is_jump_charging = true
	if Input.is_action_just_released("up"):
		is_jump_charging = false

	if is_jump_charging:
		velocity.y+=JUMP_INCREMENT
	if velocity.y <= JUMP_VELOCITY:
		is_jump_charging = false

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		is_moving = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		is_moving = false

	move_and_slide()
	
	# Clamp player's position to prevent falling off the sides of the map.
	# The level boundaries are hardcoded here based on the scenes provided.
	var map_width = 1152.0
	var player_width = 60.0 # Approximate width of the player's collision shape
	
	position.x = clamp(position.x, player_width / 2, map_width - player_width / 2)
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	var ray_direction: Vector2 = (mouse_pos - raycast.global_position).normalized()
	var pupil_position = Vector2(pupil_center.x+17*cos(ray_direction.angle()),pupil_center.y+17*sin(ray_direction.angle()))
	pupil.position = pupil_position
	
	raycast.target_position = ray_direction*RAY_LENGTH
	gaze_light.rotation = ray_direction.angle()
	
	
	if raycast.is_colliding():
		var object_hit = raycast.get_collider()
		if object_hit != fading_object and fading_object != null:
			fading_object.gaze_exited()
		if object_hit != null and object_hit.has_method("gaze_entered"):
			object_hit.gaze_entered()
			fading_object = object_hit
	elif fading_object != null:
		fading_object.gaze_exited()
		fading_object = null
func _unhandled_input(event):
	if event.is_action_pressed("toggle_eyes"):
		eyes_are_open = !eyes_are_open
		print("changing eye state")
		if eyes_are_open:
			PhospheneManager.hide_phosphene()
		elif !eyes_are_open:
			PhospheneManager.trigger_phosphene_effect()
func bounce():
	print(velocity.y)
	velocity.y = velocity.y* -1.0 - 50
