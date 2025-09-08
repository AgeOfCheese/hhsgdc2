# PhospheneManager.gd
extends Node

var viewport: Viewport
var phosphene_sprite: Sprite2D
var phosphene_texture: ImageTexture
var fade_tween: Tween
var phosphene_light
# The player is now dynamically found in each function
# @onready var player = get_tree().current_scene.get_node("player")

func _ready():
	# For autoload, we need to add the sprite to the current scene's UI layer
	setup_phosphene_sprite()

func get_current_player():
	# Finds the player node in the current scene
	return get_tree().current_scene.get_node("player")

func setup_phosphene_sprite():
	viewport = get_tree().current_scene.get_viewport()
	
	# Create the phosphene sprite and add it as a child of this node
	phosphene_sprite = Sprite2D.new()
	phosphene_sprite.name = "PhospheneSprite"
	add_child(phosphene_sprite)
	phosphene_sprite.z_index = 100
	phosphene_sprite.visible = false

func capture_phosphene():
	# Wait one frame to ensure everything is rendered
	var player = get_current_player()
	var flash = DirectionalLight2D.new()
	get_tree().current_scene.add_child(flash)
	if player != null:
		player.visible = false
	await get_tree().process_frame
	await get_tree().process_frame
	var img = viewport.get_texture().get_image()
	img.save_png("res://sprites/sprite.png")
	phosphene_texture = ImageTexture.create_from_image(img)
	flash.queue_free()
	if player != null:
		player.visible = true
	if img == null:
		print("img was null")
	
	# Apply the texture to sprite
	phosphene_sprite.texture = phosphene_texture
	
	var screen_size = viewport.get_visible_rect().size
	var texture_size = phosphene_sprite.texture.get_size()
	if texture_size.x > 0 and texture_size.y > 0:
		phosphene_sprite.scale = screen_size / texture_size
	
	phosphene_sprite.modulate = Color(0.3, 0.3, 0.8, 1.0)  
	phosphene_sprite.position = screen_size / 2.0


func show_phosphene(duration: float = 3.0):
	if phosphene_texture == null:
		print("texture was null")
		return
	var player = get_current_player()
	if player != null:
		player.visible = false
	phosphene_sprite.visible = true
	phosphene_sprite.texture.get_image()
	phosphene_sprite.modulate.a = 1.0
	
	# Fade out the phosphene over time
	if fade_tween:
		fade_tween.kill()
	phosphene_light = DirectionalLight2D.new()
	get_tree().current_scene.add_child(phosphene_light)
	
	fade_tween = create_tween()
	fade_tween.tween_property(phosphene_light, "energy", 0.0, duration)
	fade_tween.tween_callback(func(): phosphene_sprite.visible = false)


func hide_phosphene():
	phosphene_sprite.visible = false
	if phosphene_light:
		phosphene_light.queue_free()
	var player = get_current_player()
	if player != null:
		player.visible = true

# Call this when switching from "eyes open" to "eyes closed"
func trigger_phosphene_effect():
	await capture_phosphene()
	show_phosphene(3.0)  # Show for 3 seconds
