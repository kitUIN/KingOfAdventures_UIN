extends CharacterBody2D

# 武器类型枚举
enum WeaponMode {
	SINGLE_HAND,  # 单手武器模式（左右手分别装备）
	DUAL_HAND     # 双手武器模式
}

# 引用管理器类
const AttackSystemClass = preload("res://scripts/player/attack_system.gd")
const AnimationManagerClass = preload("res://scripts/player/animation_manager.gd")
const EquipmentManagerClass = preload("res://scripts/player/equipment_manager.gd")
const MovementControllerClass = preload("res://scripts/player/movement_controller.gd")

# 导出参数
@export var gravity: float = 1200.0
@export var jump_force: float = -500.0
@export var speed: float = 100.0
@export var hair_type: String = "hear_1" # 头发类型设置
@export var eye_type: String = "eye_1" # 眼睛类型设置

# 武器设置
@export var weapon_mode: WeaponMode = WeaponMode.SINGLE_HAND
@export var left_hand_weapon: String = "buckler_1" # 左手武器（盾牌）
@export var right_hand_weapon: String = "short_sword1" # 右手武器（短剑）
@export var dual_hand_weapon: String = "greatsword_1" # 双手武器（大剑）

# 节点引用
@onready var anim = $Body
@onready var hear_node = $Hear
@onready var eye_node = $Eye
@onready var left_hand_node = $LeftHand
@onready var right_hand_node = $RightHand
@onready var dual_hand_node = $Hand

# 管理器系统
var attack_system: AttackSystemClass
var animation_manager: AnimationManagerClass
var equipment_manager: EquipmentManagerClass
var movement_controller: MovementControllerClass


func _physics_process(delta: float) -> void:
	# 处理攻击系统
	attack_system.handle_timers(delta)
	attack_system.handle_input()
	
	# 处理移动（攻击时限制移动）
	var input_dir = movement_controller.handle_movement(delta, attack_system.can_move())
	
	# 动画控制
	if not attack_system.is_attacking:
		animation_manager.play_movement_animation(is_on_floor(), input_dir)
	
	# 根据方向翻转（攻击时也需要翻转）
	if input_dir != 0:
		animation_manager.set_flip(input_dir < 0)


func _ready() -> void:
	hide()
	initialize_systems()
	
func init(start_pos: Vector2) -> void:
	position = start_pos
	show()

# 初始化所有管理器系统
func initialize_systems() -> void:
	# 创建移动控制器
	movement_controller = MovementControllerClass.new(self, gravity, jump_force, speed)
	
	# 创建攻击系统
	attack_system = AttackSystemClass.new(self)
	attack_system.attack_started.connect(_on_attack_started)
	attack_system.attack_finished.connect(_on_attack_finished)
	
	# 创建动画管理器
	animation_manager = AnimationManagerClass.new(anim, weapon_mode)
	
	# 创建装备管理器
	equipment_manager = EquipmentManagerClass.new(hear_node, eye_node, left_hand_node, right_hand_node, dual_hand_node)
	equipment_manager.hair_type = hair_type
	equipment_manager.eye_type = eye_type
	equipment_manager.left_hand_weapon = left_hand_weapon
	equipment_manager.right_hand_weapon = right_hand_weapon
	equipment_manager.dual_hand_weapon = dual_hand_weapon
	equipment_manager.weapon_mode = weapon_mode
	equipment_manager.equipment_loaded.connect(_on_equipment_loaded)
	equipment_manager.equipment_mode_changed.connect(_on_equipment_mode_changed)
	
	# 初始化装备
	equipment_manager.initialize_equipment()
	
	# 设置动画管理器的引用
	setup_animation_references()

# 设置动画管理器的附件引用
func setup_animation_references() -> void:
	animation_manager.set_hair_animation(equipment_manager.get_hair_animation())
	animation_manager.set_eye_animation(equipment_manager.get_eye_animation())
	var weapon_anims = equipment_manager.get_weapon_animations()
	animation_manager.set_weapon_animations(weapon_anims[0], weapon_anims[1], weapon_anims[2])

# 攻击开始回调
func _on_attack_started(attack_type: int) -> void:
	animation_manager.play_attack_animation(attack_type)

# 攻击结束回调
func _on_attack_finished() -> void:
	pass  # 可以在这里添加攻击结束后的逻辑

# 装备加载完成回调
func _on_equipment_loaded(equipment_type: String, equipment_name: String) -> void:
	print("装备加载完成: " + equipment_type + " - " + equipment_name)
	# 重新设置动画引用
	setup_animation_references()

# 装备模式改变回调
func _on_equipment_mode_changed(mode: int) -> void:
	animation_manager.set_weapon_mode(mode)

# 公共接口方法（为外部调用提供接口）
func set_hair_type(new_hair_type: String) -> void:
	hair_type = new_hair_type
	if equipment_manager:
		equipment_manager.set_hair_type(new_hair_type)

func set_eye_type(new_eye_type: String) -> void:
	eye_type = new_eye_type
	if equipment_manager:
		equipment_manager.set_eye_type(new_eye_type)

func set_weapon_mode(new_mode: WeaponMode) -> void:
	weapon_mode = new_mode
	if equipment_manager and animation_manager:
		equipment_manager.set_weapon_mode(new_mode)
		animation_manager.set_weapon_mode(new_mode)

func set_left_weapon(weapon_name: String) -> void:
	left_hand_weapon = weapon_name
	if equipment_manager:
		equipment_manager.set_left_weapon(weapon_name)

func set_right_weapon(weapon_name: String) -> void:
	right_hand_weapon = weapon_name
	if equipment_manager:
		equipment_manager.set_right_weapon(weapon_name)

func set_dual_weapon(weapon_name: String) -> void:
	dual_hand_weapon = weapon_name
	if equipment_manager:
		equipment_manager.set_dual_weapon(weapon_name)
