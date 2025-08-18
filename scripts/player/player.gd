extends CharacterBody2D

# 武器类型枚举
enum WeaponMode {
	SINGLE_HAND,  # 单手武器模式（左右手分别装备）
	DUAL_HAND     # 双手武器模式
}

# 性别枚举
enum Gender {
	FEMALE,  # 女性
	MALE     # 男性
}

# 引用管理器类
const AttackSystemClass = preload("res://scripts/player/attack_system.gd")
const AnimationManagerClass = preload("res://scripts/player/animation_manager.gd")
const EquipmentManagerClass = preload("res://scripts/player/equipment_manager.gd")
const MovementControllerClass = preload("res://scripts/player/movement_controller.gd")
const AttackEffectManagerClass = preload("res://scripts/player/attack_effect_manager.gd")

# 职业和技能系统类
const PlayerClassClass = preload("res://scripts/player/class_skill_system/player_class.gd")
const SkillSystemClass = preload("res://scripts/player/class_skill_system/skill_system.gd")
const PassiveSkillManagerClass = preload("res://scripts/player/class_skill_system/passive_skill_manager.gd")
const ActiveSkillManagerClass = preload("res://scripts/player/class_skill_system/active_skill_manager.gd")

# 导出参数
@export var gravity: float = 1200.0
@export var jump_force: float = -500.0
@export var speed: float = 100.0
@export var gender: Gender = Gender.FEMALE # 性别设置
@export var hair_style: int = 1 # 头发样式（1-4）
@export var eye_type: String = "eye_1" # 眼睛类型设置
@export var hat_type: String = "helmet_1" # 帽子类型设置
@export var clothing_type: String = "armor_1" # 衣服类型设置

# 职业设置
@export var player_class_type: PlayerClassClass.ClassType = PlayerClassClass.ClassType.WARRIOR

# 根据性别和样式自动生成的头发类型（内部使用）
var hair_type: String

# 武器设置
@export var weapon_mode: WeaponMode = WeaponMode.SINGLE_HAND
@export var left_hand_weapon: String = "buckler_1" # 左手武器
@export var right_hand_weapon: String = "short_sword_1" # 右手武器
@export var dual_hand_weapon: String = "greatsword_1" # 双手武器

# 节点引用
@onready var body_node = $Body
@onready var hear_node = $Hear
@onready var eye_node = $Eye
@onready var hat_node = $Hat
@onready var clothing_node = $Clothing
@onready var left_hand_node = $LeftHand
@onready var right_hand_node = $RightHand
@onready var dual_hand_node = $Hand

# 管理器系统
var attack_system: AttackSystemClass
var animation_manager: AnimationManagerClass
var equipment_manager: EquipmentManagerClass
var movement_controller: MovementControllerClass
var attack_effect_manager: AttackEffectManagerClass

# 新的职业和技能系统
var player_class: PlayerClassClass
var skill_system: SkillSystemClass
var passive_skill_manager: PassiveSkillManagerClass
var active_skill_manager: ActiveSkillManagerClass


func _physics_process(delta: float) -> void:
	# 更新技能系统
	skill_system.update_cooldowns(delta)
	skill_system.update_skill_effects(delta)
	
	# 更新被动技能
	var input_dir = Input.get_axis("ui_left", "ui_right")
	passive_skill_manager.update_passive_skills(delta, input_dir)
	
	# 处理攻击系统
	attack_system.handle_timers(delta)
	attack_system.handle_input()
	
	# 处理主动技能输入
	active_skill_manager.handle_input()
	
	# 计算速度倍数（被动技能和主动技能）
	var speed_multiplier = passive_skill_manager.get_speed_multiplier() * active_skill_manager.get_speed_multiplier()
	
	# 处理移动（攻击时限制移动，应用技能速度加成）
	input_dir = movement_controller.handle_movement(delta, attack_system.can_move(), speed_multiplier)
	
	# 动画控制
	if not attack_system.is_attacking:
		animation_manager.play_movement_animation(is_on_floor(), input_dir)
	
	# 根据方向翻转（攻击时也需要翻转）
	if input_dir != 0:
		animation_manager.set_flip(input_dir < 0)


func _ready() -> void:
	hide()
	update_hair_type() # 根据性别和样式更新头发类型
	initialize_systems()
	
func init(start_pos: Vector2) -> void:
	position = start_pos
	show()

# 初始化所有管理器系统
func initialize_systems() -> void:
	# 创建职业系统
	player_class = PlayerClassClass.new(player_class_type)
	
	# 创建技能系统
	skill_system = SkillSystemClass.new()
	
	# 创建移动控制器
	movement_controller = MovementControllerClass.new(self, gravity, jump_force, speed)
	
	# 创建攻击系统
	attack_system = AttackSystemClass.new(self)
	attack_system.attack_started.connect(_on_attack_started)
	attack_system.attack_finished.connect(_on_attack_finished)
	
	# 创建攻击特效管理器
	attack_effect_manager = AttackEffectManagerClass.new(self)
	attack_effect_manager.effect_started.connect(_on_attack_effect_started)
	attack_effect_manager.effect_finished.connect(_on_attack_effect_finished)
	
	# 创建被动技能管理器
	passive_skill_manager = PassiveSkillManagerClass.new(skill_system, movement_controller, self)
	
	# 创建主动技能管理器
	active_skill_manager = ActiveSkillManagerClass.new(skill_system, self, player_class)
	
	# 创建动画管理器
	animation_manager = AnimationManagerClass.new(body_node.get_node("AnimatedSprite2D"), weapon_mode)
	
	# 创建装备管理器
	equipment_manager = EquipmentManagerClass.new(hear_node, eye_node, hat_node, clothing_node, left_hand_node, right_hand_node, dual_hand_node)
	equipment_manager.hair_type = hair_type
	equipment_manager.eye_type = eye_type
	equipment_manager.hat_type = hat_type
	equipment_manager.clothing_type = clothing_type
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
	animation_manager.set_hat_animation(equipment_manager.get_hat_animation())
	animation_manager.set_clothing_animation(equipment_manager.get_clothing_animation())
	var weapon_anims = equipment_manager.get_weapon_animations()
	animation_manager.set_weapon_animations(weapon_anims[0], weapon_anims[1], weapon_anims[2])

# 攻击开始回调
func _on_attack_started(attack_type: int) -> void:
	animation_manager.play_attack_animation(attack_type)
	# 播放攻击特效
	attack_effect_manager.play_attack_effect(attack_type)

# 攻击结束回调
func _on_attack_finished() -> void:
	pass  # 可以在这里添加攻击结束后的逻辑

# 攻击特效开始回调
func _on_attack_effect_started(attack_type: int) -> void:
	print("攻击特效开始: 攻击类型 " + str(attack_type))

# 攻击特效结束回调
func _on_attack_effect_finished(attack_type: int) -> void:
	print("攻击特效结束: 攻击类型 " + str(attack_type))

# 装备加载完成回调
func _on_equipment_loaded(equipment_type: String, equipment_name: String) -> void:
	print("装备加载完成: " + equipment_type + " - " + equipment_name)
	# 重新设置动画引用
	setup_animation_references()

# 装备模式改变回调
func _on_equipment_mode_changed(mode: int) -> void:
	animation_manager.set_weapon_mode(mode)

# 根据性别和样式更新头发类型
func update_hair_type() -> void:
	var gender_prefix = "f" if gender == Gender.FEMALE else "m"
	hair_type = gender_prefix + "_hear_" + str(hair_style)

# 公共接口方法（为外部调用提供接口）
func set_gender(new_gender: Gender) -> void:
	gender = new_gender
	update_hair_type()
	if equipment_manager:
		equipment_manager.set_hair_type(hair_type)

func set_hair_style(new_style: int) -> void:
	# 限制样式范围在1-4之间
	hair_style = clamp(new_style, 1, 4)
	update_hair_type()
	if equipment_manager:
		equipment_manager.set_hair_type(hair_type)

func set_hair_type(new_hair_type: String) -> void:
	hair_type = new_hair_type
	if equipment_manager:
		equipment_manager.set_hair_type(new_hair_type)

func set_eye_type(new_eye_type: String) -> void:
	eye_type = new_eye_type
	if equipment_manager:
		equipment_manager.set_eye_type(new_eye_type)

func set_hat_type(new_hat_type: String) -> void:
	hat_type = new_hat_type
	if equipment_manager:
		equipment_manager.set_hat_type(new_hat_type)

func set_clothing_type(new_clothing_type: String) -> void:
	clothing_type = new_clothing_type
	if equipment_manager:
		equipment_manager.set_clothing_type(new_clothing_type)

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

# === 新的职业和技能系统接口 ===

# 设置职业
func set_player_class(new_class_type: PlayerClassClass.ClassType) -> void:
	player_class_type = new_class_type
	if player_class:
		player_class.change_class(new_class_type)

# 获取当前职业
func get_player_class() -> PlayerClassClass:
	return player_class

# 获取技能系统
func get_skill_system() -> SkillSystemClass:
	return skill_system

# 获取被动技能管理器
func get_passive_skill_manager() -> PassiveSkillManagerClass:
	return passive_skill_manager

# 获取主动技能管理器
func get_active_skill_manager() -> ActiveSkillManagerClass:
	return active_skill_manager

# 启用/禁用被动技能
func set_passive_skill(skill_id: SkillSystemClass.PassiveSkill, enabled: bool) -> void:
	if skill_system:
		skill_system.set_passive_skill(skill_id, enabled)

# 检查是否可以使用技能
func can_use_skill(skill_id: int, skill_type: SkillSystemClass.SkillType) -> bool:
	if skill_system:
		return skill_system.is_skill_available(skill_id, skill_type)
	return false

# 强制激活技能（用于调试或特殊情况）
func force_activate_skill(skill_id: int, skill_type: SkillSystemClass.SkillType) -> bool:
	if skill_system:
		return skill_system.activate_skill(skill_id, skill_type)
	return false

# === 攻击特效系统接口 ===

# 手动播放攻击特效
func play_attack_effect(attack_type: int) -> void:
	if attack_effect_manager:
		attack_effect_manager.play_attack_effect(attack_type)

# 停止特定攻击特效
func stop_attack_effect(attack_type: int) -> void:
	if attack_effect_manager:
		attack_effect_manager.stop_attack_effect(attack_type)

# 停止所有攻击特效
func stop_all_attack_effects() -> void:
	if attack_effect_manager:
		attack_effect_manager.stop_all_effects()

# 检查特效是否正在播放
func is_attack_effect_playing(attack_type: int) -> bool:
	if attack_effect_manager:
		return attack_effect_manager.is_effect_playing(attack_type)
	return false

# 获取当前播放的特效数量
func get_active_effects_count() -> int:
	if attack_effect_manager:
		return attack_effect_manager.get_active_effects_count()
	return 0
