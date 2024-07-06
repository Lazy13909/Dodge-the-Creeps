extends CanvasLayer

signal ui

var health = []
const max_health = 3
var current_health = 3

func _ready():
	$Health.hide()
	health.append($Health/HealthOne)
	health.append($Health/HealthTwo)
	health.append($Health/HealthThree)
	

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func take_damage():
	if current_health > 0:
		current_health -= 1
		health[current_health].hide()

func reset_health():
	current_health = max_health
	for heart in health:
		heart.show()

func show_game_over():
	show_message("Game Over")
	
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func _on_start_button_pressed():
	$StartButton.hide()
	ui.emit()

func _on_message_timer_timeout():
	$Message.hide()
