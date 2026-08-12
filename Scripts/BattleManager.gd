extends Node2D

@onready var player = $PlayerSide/Player1
@onready var enemy = $EnemySide/Enemy1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("=== Battle Start ===")
	await get_tree().create_timer(1.0).timeout
	player_turn()

func player_turn():
	print("[ เทิร์นผู้เล่น ]")
	player.attack(enemy)
	
	if enemy.is_dead():
		end_battle("Player")
		return
	
	await get_tree().create_timer(1.0).timeout
	enemy_turn()
	
func enemy_turn():
	print("[ เทิร์นศัตรู ]")
	enemy.attack(player)
	
	if player.is_dead():
		end_battle("Enemy")
		return
	
	await get_tree().create_timer(1.0).timeout
	player_turn()

func end_battle(winner):
	print("=== จบการต่อสู้ ===")
	print(winner + " ชนะ!")
