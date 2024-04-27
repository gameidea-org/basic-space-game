extends Node2D

var asteroid1 = preload("res://Asteroid1.tscn")
var asteroid2 = preload("res://Asteroid2.tscn")
var enemy_ship = preload("res://Enemy.tscn")

var camera

var spawn_timer = 1

var shake_screen: bool = false
var shake_screen_timer = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_viewport().get_camera_2d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# When shake_screen == true: it shakes it
	on_shake_screen(delta)
	
	if spawn_timer > 0:
		spawn_timer -= delta
	else:
		spawn_timer = 1
		
		var viewport_rectangle = get_viewport_rect()
		var spawn_position_x = randf_range(
			viewport_rectangle.position.x,
			viewport_rectangle.size.x
		)
		var spawn_position_y = viewport_rectangle.position.y - 20
		
		var spawn_probability = randf()
		
		var spawn_object
		if spawn_probability < 0.38:
			spawn_object = asteroid2.instantiate()
		elif spawn_probability < 0.78:
			spawn_object = asteroid1.instantiate()
		elif spawn_probability < 1.0:
			spawn_object = enemy_ship.instantiate()
		
		spawn_object.position = Vector2(spawn_position_x, spawn_position_y)
		self.add_child(spawn_object)


func on_shake_screen(delta):
	# Shake lightly normally
	if not shake_screen:
		return #get_viewport().get_camera_2d().offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 0.0001
	# Shake harder when impact
	if shake_screen_timer < 0:
		shake_screen = false
		shake_screen_timer = 0.3
		get_viewport().get_camera_2d().offset = Vector2(0, 0)
	else:
		shake_screen_timer -= delta
		get_viewport().get_camera_2d().offset += Vector2(randf_range(-4, 4), randf_range(-4, 4))
