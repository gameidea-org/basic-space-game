extends CharacterBody2D

var bullet = preload("res://Bullet.tscn")

var world
var player

var camera
var SPEED = 128

var frequency = 64

var shoot_timer = 1.2

func _ready():
	camera = get_viewport().get_camera_2d()
	world = get_tree().root.get_node("World")
	player = world.get_node("Player")
	
	frequency *= randf_range(-64, 64)
	
	rotation_degrees = 180

func shoot(delta):
	var this_bullet = bullet.instantiate()
	this_bullet.position = self.position
	this_bullet.direction = Vector2(0, 1)
	this_bullet.rotation_degrees = 180
	this_bullet.who_fired = self
	world.add_child(this_bullet)

func _process(delta):
	
	if shoot_timer < 0:
		shoot(delta)
		shoot_timer = 1.2
	else:
		shoot_timer -= delta
	
	self.position.y += SPEED * delta
	
	position.x += sin(deg_to_rad(position.y * frequency)) + 2
	
	if position.y > get_viewport_rect().size.y:
		queue_free()
