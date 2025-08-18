class_name ActiveSkillManager
extends RefCounted

# 引用其他系统
var skill_system
var player_ref: CharacterBody2D
var player_class

# 技能效果状态
var shield_block_active: bool = false
var berserker_active: bool = false
var war_cry_active: bool = false
var freeze_active: bool = false

# 技能效果参数
var berserker_damage_multiplier: float = 2.0
var berserker_speed_multiplier: float = 1.5
var shield_block_damage_reduction: float = 0.8
var war_cry_damage_bonus: float = 1.3
var heal_amount: float = 50.0
var teleport_distance: float = 200.0

# 冰冻目标列表（假设的敌人系统）
var frozen_targets: Array = []

func _init(skill_sys, player: CharacterBody2D, p_class):
	skill_system = skill_sys
	player_ref = player
	player_class = p_class
	
	# 连接技能系统信号
	skill_system.skill_activated.connect(_on_skill_activated)
	skill_system.skill_deactivated.connect(_on_skill_deactivated)

# 处理输入
func handle_input() -> void:
	# 技能1 - Q键
	if Input.is_action_just_pressed("skill_1"):
		activate_skill_1()
	
	# 技能2 - W键
	if Input.is_action_just_pressed("skill_2"):
		activate_skill_2()
	
	# 技能3 - E键
	if Input.is_action_just_pressed("skill_3"):
		activate_skill_3()
	
	# 技能4 - R键
	if Input.is_action_just_pressed("skill_4"):
		activate_skill_4()

# 激活技能1
func activate_skill_1() -> void:
	if player_class.get_class_type() == 0:  # WARRIOR
		# 战士：冲锋斩击
		if skill_system.activate_skill(100, 1):  # CHARGE_SLASH, ACTIVE
			perform_charge_slash()
	else:
		# 法师：火球术
		if skill_system.activate_skill(200, 1):  # FIREBALL, ACTIVE
			perform_fireball()

# 激活技能2
func activate_skill_2() -> void:
	if player_class.get_class_type() == 0:  # WARRIOR
		# 战士：盾牌格挡
		if skill_system.activate_skill(101, 1):  # SHIELD_BLOCK, ACTIVE
			perform_shield_block()
	else:
		# 法师：冰冻术
		if skill_system.activate_skill(201, 1):  # FREEZE, ACTIVE
			perform_freeze()

# 激活技能3
func activate_skill_3() -> void:
	if player_class.get_class_type() == 0:  # WARRIOR
		# 战士：狂暴
		if skill_system.activate_skill(102, 1):  # BERSERKER, ACTIVE
			perform_berserker()
	else:
		# 法师：治疗术
		if skill_system.activate_skill(202, 1):  # HEAL, ACTIVE
			perform_heal()

# 激活技能4
func activate_skill_4() -> void:
	if player_class.get_class_type() == 0:  # WARRIOR
		# 战士：战吼
		if skill_system.activate_skill(103, 1):  # WAR_CRY, ACTIVE
			perform_war_cry()
	else:
		# 法师：传送术
		if skill_system.activate_skill(203, 1):  # TELEPORT, ACTIVE
			perform_teleport()

# === 战士技能实现 ===

# 冲锋斩击
func perform_charge_slash() -> void:
	print("使用冲锋斩击!")
	# 向前冲锋
	var charge_direction = 1 if not player_ref.get_node("Body/AnimatedSprite2D").flip_h else -1
	var charge_force = Vector2(charge_direction * 300, 0)
	player_ref.velocity += charge_force
	
	# 造成额外伤害（在攻击系统中处理）
	# 这里可以发出信号通知攻击系统

# 盾牌格挡
func perform_shield_block() -> void:
	print("使用盾牌格挡!")
	shield_block_active = true

# 狂暴
func perform_berserker() -> void:
	print("使用狂暴!")
	berserker_active = true

# 战吼
func perform_war_cry() -> void:
	print("使用战吼!")
	war_cry_active = true

# === 法师技能实现 ===

# 火球术
func perform_fireball() -> void:
	print("使用火球术!")
	# 创建火球弹射物
	create_projectile("fireball")

# 冰冻术
func perform_freeze() -> void:
	print("使用冰冻术!")
	freeze_active = true
	# 冰冻附近的敌人（假设的实现）
	freeze_nearby_enemies()

# 治疗术
func perform_heal() -> void:
	print("使用治疗术!")
	# 恢复生命值（假设有生命值系统）
	heal_player(heal_amount)

# 传送术
func perform_teleport() -> void:
	print("使用传送术!")
	# 传送到鼠标位置或前方
	var teleport_direction = 1 if not player_ref.get_node("Body/AnimatedSprite2D").flip_h else -1
	var teleport_position = player_ref.global_position + Vector2(teleport_direction * teleport_distance, 0)
	player_ref.global_position = teleport_position

# === 辅助函数 ===

# 创建弹射物
func create_projectile(projectile_type: String) -> void:
	# 这里应该创建实际的弹射物
	print("创建弹射物: " + projectile_type)

# 冰冻附近敌人
func freeze_nearby_enemies() -> void:
	# 这里应该检测附近的敌人并冰冻他们
	print("冰冻附近敌人")

# 治疗玩家
func heal_player(amount: float) -> void:
	# 这里应该调用生命值系统
	print("治疗玩家: " + str(amount))

# 技能激活回调
func _on_skill_activated(skill_id: int, skill_type: int) -> void:
	print("技能激活: " + skill_system.get_skill_name(skill_id, skill_type))

# 技能结束回调
func _on_skill_deactivated(skill_id: int, skill_type: int) -> void:
	print("技能结束: " + skill_system.get_skill_name(skill_id, skill_type))
	
	# 根据技能类型处理结束效果
	if player_class.get_class_type() == 0:  # WARRIOR
		match skill_id:
			101:  # SHIELD_BLOCK
				shield_block_active = false
			102:  # BERSERKER
				berserker_active = false
			103:  # WAR_CRY
				war_cry_active = false
	else:
		match skill_id:
			201:  # FREEZE
				freeze_active = false
				# 解除冰冻效果
				unfreeze_all_targets()

# 解除所有冰冻效果
func unfreeze_all_targets() -> void:
	frozen_targets.clear()
	print("解除所有冰冻效果")

# 获取当前伤害倍数
func get_damage_multiplier() -> float:
	var multiplier = 1.0
	
	if berserker_active:
		multiplier *= berserker_damage_multiplier
	
	if war_cry_active:
		multiplier *= war_cry_damage_bonus
	
	return multiplier

# 获取速度倍数
func get_speed_multiplier() -> float:
	if berserker_active:
		return berserker_speed_multiplier
	return 1.0

# 获取伤害减免
func get_damage_reduction() -> float:
	if shield_block_active:
		return shield_block_damage_reduction
	return 0.0

# 检查是否有特定技能效果
func has_effect(effect_name: String) -> bool:
	match effect_name:
		"shield_block":
			return shield_block_active
		"berserker":
			return berserker_active
		"war_cry":
			return war_cry_active
		"freeze":
			return freeze_active
		_:
			return false
