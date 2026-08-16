extends Node2D

@onready var player = $PlayerSide/Player1
@onready var enemy = $EnemySide/Enemy1
@onready var attack_button = $UI/AttackButton

var is_player_turn = true

func _ready() -> void:
	print("=== Battle Start ===")
	attack_button.pressed.connect(_on_attack_pressed)

func _on_attack_pressed():
	if not is_player_turn:
		return
	
	# ผู้เล่นโจมตี
	is_player_turn = false
	attack_button.disabled = true
	player.attack(enemy)
	
	if enemy.is_dead():
		end_battle("Player")
		return
	
	# รอแล้วศัตรูโจมตี
	await get_tree().create_timer(1.0).timeout
	enemy_turn()

func enemy_turn():
	print("[ เทิร์นศัตรู ]")
	enemy.attack(player)
	
	if player.is_dead():
		end_battle("Enemy")
		return
	
	# คืนเทิร์นให้ผู้เล่น
	is_player_turn = true
	attack_button.disabled = false
	print("[ เทิร์นผู้เล่น — กดโจมตี ]")

func end_battle(winner):
	print("=== จบการต่อสู้ ===")
	print(winner + " ชนะ!")
	attack_button.disabled = true
