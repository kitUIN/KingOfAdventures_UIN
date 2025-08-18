# 技能系统演示和使用说明脚本
# 这个脚本展示了如何使用新实现的职业和技能系统

extends RefCounted
class_name SkillDemo

# === 职业系统使用说明 ===
# 1. 设置玩家职业
func set_player_to_warrior(player: CharacterBody2D) -> void:
	player.set_player_class(0)  # WARRIOR
	print("玩家职业设置为：战士")

func set_player_to_mage(player: CharacterBody2D) -> void:
	player.set_player_class(1)  # MAGE
	print("玩家职业设置为：法师")

# 2. 获取职业信息
func show_class_info(player: CharacterBody2D) -> void:
	var player_class = player.get_player_class()
	if player_class:
		print("当前职业：", player_class.get_class_name())
		print("职业描述：", player_class.get_description())
		print("主动技能：", player_class.get_active_skills())

# === 被动技能系统使用说明 ===
# 被动技能自动启用，可以通过以下方式控制

# 控制奔跑技能
func toggle_sprint_skill(player: CharacterBody2D, enabled: bool) -> void:
	player.set_passive_skill(0, enabled)  # SPRINT
	print("奔跑技能", "启用" if enabled else "禁用")

# 控制冲刺攻击技能
func toggle_dash_attack_skill(player: CharacterBody2D, enabled: bool) -> void:
	player.set_passive_skill(1, enabled)  # DASH_ATTACK
	print("冲刺攻击技能", "启用" if enabled else "禁用")

# 控制二段跳技能
func toggle_double_jump_skill(player: CharacterBody2D, enabled: bool) -> void:
	player.set_passive_skill(2, enabled)  # DOUBLE_JUMP
	print("二段跳技能", "启用" if enabled else "禁用")

# === 主动技能系统使用说明 ===
# 主动技能通过按键触发：Q键(技能1), W键(技能2), E键(技能3), R键(技能4)

# 检查技能冷却状态
func check_skill_cooldowns(player: CharacterBody2D) -> void:
	var skill_system = player.get_skill_system()
	if not skill_system:
		return
	
	print("=== 技能冷却状态 ===")
	var player_class = player.get_player_class()
	
	if player_class.get_class_type() == 0:  # WARRIOR
		print("冲锋斩击冷却：", skill_system.get_skill_cooldown(100))
		print("盾牌格挡冷却：", skill_system.get_skill_cooldown(101))
		print("狂暴冷却：", skill_system.get_skill_cooldown(102))
		print("战吼冷却：", skill_system.get_skill_cooldown(103))
	else:
		print("火球术冷却：", skill_system.get_skill_cooldown(200))
		print("冰冻术冷却：", skill_system.get_skill_cooldown(201))
		print("治疗术冷却：", skill_system.get_skill_cooldown(202))
		print("传送术冷却：", skill_system.get_skill_cooldown(203))

# 强制激活技能（用于调试）
func force_activate_warrior_skill(player: CharacterBody2D, skill_index: int) -> void:
	var skills = [100, 101, 102, 103]  # CHARGE_SLASH, SHIELD_BLOCK, BERSERKER, WAR_CRY
	
	if skill_index >= 0 and skill_index < skills.size():
		player.force_activate_skill(skills[skill_index], 1)  # ACTIVE

func force_activate_mage_skill(player: CharacterBody2D, skill_index: int) -> void:
	var skills = [200, 201, 202, 203]  # FIREBALL, FREEZE, HEAL, TELEPORT
	
	if skill_index >= 0 and skill_index < skills.size():
		player.force_activate_skill(skills[skill_index], 1)  # ACTIVE

# === 系统状态监控 ===
func monitor_system_status(player: CharacterBody2D) -> void:
	var passive_manager = player.get_passive_skill_manager()
	var active_manager = player.get_active_skill_manager()
	
	if passive_manager:
		print("=== 被动技能状态 ===")
		print("正在奔跑：", passive_manager.get_is_sprinting())
		print("速度倍数：", passive_manager.get_speed_multiplier())
		print("可以冲刺攻击：", passive_manager.can_dash_attack())
	
	if active_manager:
		print("=== 主动技能效果 ===")
		print("盾牌格挡激活：", active_manager.has_effect("shield_block"))
		print("狂暴激活：", active_manager.has_effect("berserker"))
		print("战吼激活：", active_manager.has_effect("war_cry"))
		print("冰冻激活：", active_manager.has_effect("freeze"))
		print("伤害倍数：", active_manager.get_damage_multiplier())

# === 使用示例 ===
# 在游戏中调用这些函数来测试技能系统
func demo_usage(player: CharacterBody2D) -> void:
	print("=== 技能系统演示 ===")
	
	# 1. 设置为战士职业
	set_player_to_warrior(player)
	show_class_info(player)
	
	# 2. 启用所有被动技能
	toggle_sprint_skill(player, true)
	toggle_dash_attack_skill(player, true)
	toggle_double_jump_skill(player, true)
	
	# 3. 检查技能状态
	check_skill_cooldowns(player)
	monitor_system_status(player)
	
	print("=== 控制说明 ===")
	print("移动：A/D键")
	print("跳跃：K键")
	print("攻击：J键")
	print("奔跑：双击并按住A或D键")
	print("二段跳：在空中时按K键")
	print("技能1：Q键")
	print("技能2：W键")
	print("技能3：E键")
	print("技能4：R键")
