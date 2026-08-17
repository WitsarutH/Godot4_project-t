extends Sprite2D

@export var unit_name = "Unit"
@export var max_hp = 100
@export var atk = 30

var hp

@onready var hp_bar = $HPBar

# Signal บอกว่าตัวละครนี้ถูกคลิก
signal clicked(unit)

func _ready() -> void:
	hp = max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	print(unit_name + " พร้อมแล้ว HP: " + str(hp))
	
	# เชื่อม Area2D กับฟังก์ชันรับคลิก (ถ้ามี)
	if has_node("Area2D"):
		$Area2D.input_pickable = true
		$Area2D.input_event.connect(_on_area_clicked)

func _on_area_clicked(viewport, event, shape_idx):
	# เช็คว่าเป็นการคลิกซ้ายไหม
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("clicked", self)

func take_damage(damage):
	hp -= damage
	hp_bar.value = hp
	print(unit_name + " โดนโจมตี เหลือ HP: " + str(hp))
	if hp <= 0:
		print(unit_name + " ตายแล้ว!")

func attack(target):
	print(unit_name + " โจมตี " + target.unit_name)
	target.take_damage(atk)

func is_dead():
	return hp <= 0
