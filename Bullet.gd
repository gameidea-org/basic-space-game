extends Area2D

var who_fired
var direction = Vector2(0, -1)
const SPEED = 512

var timer = 0.8

var destroyed = false
var exploded = false


var world

func _ready():
	world = get_tree().root.get_node("World")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not destroyed:
		self.position += direction * SPEED * delta
		
		if timer < 0:
			queue_free()
		timer -= delta
	else:
		explode(delta)


func explode(delta):
	if not exploded:
		exploded = true
		$Explosion.visible = true
		$Sprite2D.visible = false
		$Explosion.play()
		$ExplosionSound.play()
		world.shake_screen = true
	
	if exploded and not $Explosion.is_playing() and not $ExplosionSound.is_playing():
		queue_free()

func _on_body_entered(body):
	if body != who_fired:
		destory(body)


func _on_area_entered(area):
	if area != who_fired:
		destory(area)

func destory(entity):
	entity.queue_free()
	if who_fired != null:
		if who_fired.has_method("increase_score"):
			who_fired.increase_score(1)
	destroyed = true
