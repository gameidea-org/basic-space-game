extends Node2D

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

func create_background():
	var background = Sprite2D.new()
	background.region_enabled = true
	
	background.region_rect.size = get_viewport_rect().size * 64.0
	background.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	background.texture = load("res://assets/Backgrounds/black.png")
	return background

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Player extends Sprite2D:
	var health = 8
	var speed = 8
	
	# We load a png image as a texture for this sprite
	func _init():
		self.texture = load("res://assets/PNG/playerShip2_red.png")
	
	# We update position based on user input
	func move(delta):
		if Input.is_action_pressed("ui_up"):
			self.position.y -= speed
		if Input.is_action_pressed("ui_down"):
			self.position.y += speed
		if Input.is_action_pressed("ui_right"):
			self.position.x += speed
		if Input.is_action_pressed("ui_left"):
			self.position.x -= speed


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Asteroid extends Sprite2D:
	var speed = 140 + randf() * 64
	# We load a png image as a texture for this sprite
	func _init():
		self.texture = load("res://assets/PNG/Meteors/meteorBrown_big" + str(randi_range(1,4)) + ".png")
	
	# We update position based on user input
	func move(delta):
		var direction = Vector2(0, 1)
		self.position += direction * speed * delta

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

func get_camera_rect() -> Rect2:
	var half_size = get_viewport_rect().size * 0.5
	return Rect2(camera.position - half_size, camera.position + half_size)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

func is_colliding(sprite1 : Sprite2D, sprite2: Sprite2D) -> bool:
	var rect1 = Rect2(sprite1.global_position, sprite1.get_rect().size)
	var rect2 = Rect2(sprite2.global_position, sprite2.get_rect().size)
	return rect1.intersects(rect2)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

var player
var camera

var asteroids = {}

var health_label
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(create_background())
	
	player = Player.new()
	add_child(player)
	
	camera = Camera2D.new()
	add_child(camera)
	
	health_label = Label.new()
	health_label.position = get_camera_rect().position
	add_child(health_label)

var elapsed_time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_label.text = "Health: " + str(player.health)
	player.move(delta)
	
	while asteroids.size() < 16 and elapsed_time > 1:
		elapsed_time = 0.0
		var asteroid = Asteroid.new()
		var camera_rect = get_camera_rect()
		asteroid.position = Vector2(randf_range(camera_rect.position.x, camera_rect.size.x), camera_rect.position.y)
		asteroids[asteroid.to_string()] = asteroid
		add_child(asteroid)
	
	for key in asteroids.keys():
		asteroids[key].move(delta)
		if is_colliding(asteroids[key], player):
			player.health -= 1
			asteroids[key].queue_free()
			asteroids.erase(key)
			continue
		if asteroids[key].position.y > get_camera_rect().size.y:
			asteroids[key].queue_free()
			asteroids.erase(key)
			continue
	
	elapsed_time += delta
	print(player.health)
