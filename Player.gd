extends CharacterBody2D

var bullet = preload("res://Bullet.tscn")

var world

var health = 100
const SPEED = 20

var score = 0

var my_velocity = Vector2(0, 0)


func _ready():
	world = get_tree().root.get_node("World")

# We update position based on user input
func move(delta):
	if Input.is_action_pressed("ui_up"):
		my_velocity.y -= SPEED * delta
	if Input.is_action_pressed("ui_down"):
		my_velocity.y += SPEED * delta
	if Input.is_action_pressed("ui_right"):
		my_velocity.x += SPEED * delta
	if Input.is_action_pressed("ui_left"):
		my_velocity.x -= SPEED * delta
	
	self.position += my_velocity
	my_velocity -= my_velocity * 0.04

func shoot(delta):
	if Input.is_action_just_pressed("mouse_left_button"):
		var this_bullet = bullet.instantiate()
		this_bullet.position = self.position
		this_bullet.direction = Vector2(0, -1)
		this_bullet.who_fired = self
		world.add_child(this_bullet)

func _physics_process(delta):
	move(delta)
	shoot(delta)
	



func reduce_health(amount):
	world.shake_screen = true
	$HitSound.play()
	health -= amount
	var health_label = world.get_node("GUI").get_node("HealthBar").get_node("HealthLabel")
	
	if health < 0:
		queue_free()
		get_tree().change_scene_to_file("res://MainMenu.tscn")
	
	health_label.text = "HEALTH " + str(health)

func increase_score(amount):
	score += 1
	var score_label = world.get_node("GUI").get_node("ScoreBar").get_node("ScoreLabel")
	score_label.text = "SCORE " + str(score)
