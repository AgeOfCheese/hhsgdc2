# fadeable_tile_map.gd
extends TileMapLayer

var fade_speed: float = 0.5
var fading_platforms = {}
signal destroyed

func get_platform_at_tile(coords: Vector2i) -> Array:
	var platform_tiles = []
	var visited = {}
	var stack = [coords]
	var tile_data = get_cell_tile_data(coords)
	
	if tile_data == null:
		return platform_tiles
		
	while stack.size() > 0:
		var current_tile = stack.pop_back()
		
		if visited.has(current_tile):
			continue
		
		visited[current_tile] = true
		platform_tiles.append(current_tile)
		
		# Check neighbors (up, down, left, right)
		var neighbors = [
			Vector2i(current_tile.x, current_tile.y - 1),
			Vector2i(current_tile.x, current_tile.y + 1),
			Vector2i(current_tile.x - 1, current_tile.y),
			Vector2i(current_tile.x + 1, current_tile.y)
		]
		
		for neighbor in neighbors:
			var neighbor_data = get_cell_tile_data(neighbor)
			if neighbor_data != null and not visited.has(neighbor):
				stack.append(neighbor)
				
	return platform_tiles

func start_fading_platform(coords: Vector2i):
	if not fading_platforms.has(coords):
		var platform = get_platform_at_tile(coords)
		if not platform.is_empty():
			fading_platforms[coords] = {
				"tiles": platform,
				"alpha": 1.0,
				"faded": false
			}

func stop_fading_platform(coords: Vector2i):
	if fading_platforms.has(coords):
		fading_platforms.erase(coords)

func _process(delta):
	var faded_this_frame = []
	
	for platform_start_coords in fading_platforms:
		var platform_data = fading_platforms[platform_start_coords]
		
		if platform_data["alpha"] > 0:
			platform_data["alpha"] -= fade_speed * delta
			if platform_data["alpha"] <= 0:
				platform_data["alpha"] = 0
				platform_data["faded"] = true
				
			# Update modulation for all tiles in the platform
			for tile_coords in platform_data["tiles"]:
				modulate = Color(1, 1, 1, platform_data["alpha"])
		
		# Remove faded platforms
		if platform_data["faded"]:
			for tile_coords in platform_data["tiles"]:
				erase_cell(tile_coords)
			faded_this_frame.append(platform_start_coords)
			destroyed.emit()
	
	# Clean up faded platforms
	for platform_coords in faded_this_frame:
		fading_platforms.erase(platform_coords)

func get_platform_key(coords: Vector2i) -> Vector2i:
	var platform_tiles = get_platform_at_tile(coords)
	if not platform_tiles.is_empty():
		return platform_tiles[0]
	return coords
