extends Area2D
signal hit

@export var speed = 200
const max_health = 3
var current_health = 3
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	show()

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		take_damage(1)

func take_damage(amount):
	current_health -= 1
	print(current_health)
	if current_health <= 0:
		hide()
		hit.emit()
		current_health = max_health 

