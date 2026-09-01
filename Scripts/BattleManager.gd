extends Node2D

var player_team = []
var enemy_team = []
var selected_target = null
var is_player_turn = true

@onready var attack_button = $UI/AttackButton
@onready var result_screen = $UI/ResultScreen
@onready var result_label = $UI/ResultScreen/Panel/ResultLabel
@onready var restart_button = $UI/ResultScreen/Panel/RestartButton

func _ready():
	player_team.append($PlayerSide/Player1)
	player_team.append($PlayerSide/Player2)
	enemy_team.append($EnemySide/Enemy1)
	enemy_team.append($EnemySide/Enemy2)
	
	# เชื่อม signal คลิกของศัตรูแต่ละตัว
	for enemy in enemy_team:
		enemy.clicked.connect(_on_enemy_clicked)
	
	attack_button.pressed.connect(_on_attack_pressed)
	attack_button.disabled = true
	
	# ซ่อน ResultScreen ตอนเริ่มเกม
	result_screen.visible = false
	
	# เชื่อมปุ่ม Restart
	restart_button.pressed.connect(_on_restart_pressed)

	print("=== Battle Start ===")
	print("[ เลือกเป้าหมายที่จะโจมตี ]")

func _on_restart_pressed():
	# โหลด Scene ใหม่ทั้งหมด
	get_tree().reload_current_scene()

func _on_enemy_clicked(unit):
	# รับเป้าหมายที่คลิกเลือก
	if not is_player_turn or unit.is_dead():
		return
	selected_target = unit
	attack_button.disabled = false
	print("เลือกเป้าหมาย: " + unit.unit_name)

func _on_attack_pressed():
	if not is_player_turn or selected_target == null:
		return
	
	is_player_turn = false
	attack_button.disabled = true
	
	var attacker = get_first_alive(player_team)
	attacker.attack(selected_target)
	selected_target = null
	
	if not has_alive(enemy_team):
		end_battle("Player")
		return
	
	await get_tree().create_timer(1.0).timeout
	enemy_turn()

func enemy_turn():
	print("[ เทิร์นศัตรู ]")
	for enemy in enemy_team:
		if enemy.is_dead():
			continue
		var target = get_first_alive(player_team)
		if target:
			enemy.attack(target)
		await get_tree().create_timer(0.5).timeout
	
	if not has_alive(player_team):
		end_battle("Enemy")
		return
	
	is_player_turn = true
	print("[ เลือกเป้าหมายที่จะโจมตี ]")

func get_first_alive(team):
	for unit in team:
		if not unit.is_dead():
			return unit
	return null

func has_alive(team):
	for unit in team:
		if not unit.is_dead():
			return true
	return false

func end_battle(winner):
	print("=== จบการต่อสู้ ===")
	print(winner + " ชนะ!")
	attack_button.disabled = true
	result_screen.visible = true
	if winner == "Player":
		result_label.text = "🏆 ชนะ!"
	else:
		result_label.text = "💀 แพ้!"
