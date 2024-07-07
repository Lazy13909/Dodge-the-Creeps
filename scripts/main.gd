extends Node

@export var mob_scene: PackedScene
var score
var best_result = 0

func _ready():
	best_result = load_best_result()
	$UI.update_high_score(load_best_result())

func new_game():
	score = 0
	$Player.show()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$UI/Health.show()
	$UI.reset_health()
	$UI.update_score(score)
	$UI.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$UI/BestResult.hide()
	$UI/QuitButton.hide()
	
	$Music.play()
	
func _on_start_timer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
func _on_score_timer_timeout():
	score += 1
	$UI.update_score(score)
	if score > best_result:
		$UI.update_high_score(score)
		best_result = score
		
func game_over():
	save_best_result(best_result)
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$UI.show_game_over()
	$UI/BestResult.show()
	
	$Music.stop()
	$DeathSound.play()
	
func save_best_result(best_score_to_save):
	var file = FileAccess.open("user://best_result.dat", FileAccess.WRITE)
	if file:
		file.store_string(str(best_score_to_save))
	else:
		print("Error saving best result")
		
func load_best_result() -> int:
	var file = FileAccess.open("user://best_result.dat", FileAccess.READ)
	if file:
		var loaded_score = int(file.get_as_text())
		return loaded_score
	else:
		print("No best result found, returing default value")
		return 0
	
