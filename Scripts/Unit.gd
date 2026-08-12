extends Sprite2D

@export var unit_name = "Unit"
var hp
@export var max_hp = 100
@export var atk = 30

@onready var hp_bar = $HPBar

func _ready() -> void:
	hp = max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	print(unit_name + " พร้อมแล้ว HP: " + str(hp))
	
func attack(target):
	print(unit_name + " โจมตี " + target.unit_name)
	target.take_damage(atk)

func take_damage(damage):
	hp -= damage
	hp_bar.value = hp
	print(unit_name + " โดนโจมตี เหลือ HP: " + str(hp))
	
	if hp <= 0:
		print(unit_name + " ตายแล้ว!")

func is_dead():
	return hp <= 0
