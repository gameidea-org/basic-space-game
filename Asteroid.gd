extends Area2D

var camera
var SPEED = 32
var ROTATION_SPEED = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_viewport().get_camera_2d()
	SPEED *= randf_range(1.0, 3.0)
	ROTATION_SPEED *= randf_range(-4.0, 4.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.y += SPEED * delta
	self.rotation += deg_to_rad(ROTATION_SPEED * delta)
	
	if position.y > get_viewport_rect().size.y:
		queue_free()


func _on_body_entered(body):
	if body.has_method("reduce_health"):
		body.reduce_health(10)
