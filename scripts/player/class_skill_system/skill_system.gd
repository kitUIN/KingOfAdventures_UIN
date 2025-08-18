class_name SkillSystem
extends RefCounted

# 技能类型枚举
enum SkillType {
	PASSIVE,    # 被动技能
	ACTIVE      # 主动技能
}

# 被动技能枚举
enum PassiveSkill {
	SPRINT,         # 奔跑技能
	DASH_ATTACK,    # 奔跑突刺攻击
	DOUBLE_JUMP     # 二段跳
}

# 主动技能枚举 - 战士
enum WarriorSkill {
	CHARGE_SLASH,   # 冲锋斩击
	SHIELD_BLOCK,   # 盾牌格挡
	BERSERKER,      # 狂暴
	WAR_CRY         # 战吼
}

# 主动技能枚举 - 法师
enum MageSkill {
	FIREBALL,       # 火球术
	FREEZE,         # 冰冻术
	HEAL,           # 治疗术
	TELEPORT        # 传送术
}

# 技能冷却时间
var skill_cooldowns: Dictionary = {}
var skill_durations: Dictionary = {}

# 被动技能状态
var passive_skills: Dictionary = {
	PassiveSkill.SPRINT: true,
	PassiveSkill.DASH_ATTACK: true,
	PassiveSkill.DOUBLE_JUMP: true
}

# 主动技能冷却数据
var active_skill_data: Dictionary = {
	# 战士技能 (使用值而非枚举)
	100: {"cooldown": 5.0, "duration": 1.0, "current_cooldown": 0.0},  # CHARGE_SLASH
	101: {"cooldown": 8.0, "duration": 3.0, "current_cooldown": 0.0},  # SHIELD_BLOCK
	102: {"cooldown": 15.0, "duration": 8.0, "current_cooldown": 0.0}, # BERSERKER
	103: {"cooldown": 12.0, "duration": 5.0, "current_cooldown": 0.0}, # WAR_CRY
	
	# 法师技能 (使用值而非枚举)
	200: {"cooldown": 3.0, "duration": 0.5, "current_cooldown": 0.0},  # FIREBALL
	201: {"cooldown": 6.0, "duration": 4.0, "current_cooldown": 0.0},  # FREEZE
	202: {"cooldown": 10.0, "duration": 2.0, "current_cooldown": 0.0}, # HEAL
	203: {"cooldown": 8.0, "duration": 0.3, "current_cooldown": 0.0}   # TELEPORT
}

# 技能状态信号
signal skill_activated(skill_id: int, skill_type: SkillType)
signal skill_deactivated(skill_id: int, skill_type: SkillType)
signal skill_cooldown_finished(skill_id: int, skill_type: SkillType)

# 当前激活的技能
var active_effects: Dictionary = {}

func _init():
	pass

# 更新技能冷却
func update_cooldowns(delta: float) -> void:
	for skill_id in active_skill_data:
		var skill_data = active_skill_data[skill_id]
		if skill_data["current_cooldown"] > 0:
			skill_data["current_cooldown"] -= delta
			if skill_data["current_cooldown"] <= 0:
				skill_data["current_cooldown"] = 0
				skill_cooldown_finished.emit(skill_id, SkillType.ACTIVE)

# 检查技能是否可用
func is_skill_available(skill_id: int, skill_type: SkillType) -> bool:
	if skill_type == SkillType.PASSIVE:
		return passive_skills.get(skill_id, false)
	else:
		if skill_id in active_skill_data:
			return active_skill_data[skill_id]["current_cooldown"] <= 0
	return false

# 激活技能
func activate_skill(skill_id: int, skill_type: SkillType) -> bool:
	if not is_skill_available(skill_id, skill_type):
		return false
	
	if skill_type == SkillType.ACTIVE:
		var skill_data = active_skill_data[skill_id]
		# 设置冷却时间
		skill_data["current_cooldown"] = skill_data["cooldown"]
		# 记录激活状态
		active_effects[skill_id] = skill_data["duration"]
	
	skill_activated.emit(skill_id, skill_type)
	return true

# 更新技能持续效果
func update_skill_effects(delta: float) -> void:
	var skills_to_remove = []
	
	for skill_id in active_effects:
		active_effects[skill_id] -= delta
		if active_effects[skill_id] <= 0:
			skills_to_remove.append(skill_id)
			skill_deactivated.emit(skill_id, SkillType.ACTIVE)
	
	for skill_id in skills_to_remove:
		active_effects.erase(skill_id)

# 检查技能是否正在生效
func is_skill_active(skill_id: int) -> bool:
	return skill_id in active_effects

# 获取技能剩余冷却时间
func get_skill_cooldown(skill_id: int) -> float:
	if skill_id in active_skill_data:
		return active_skill_data[skill_id]["current_cooldown"]
	return 0.0

# 获取技能剩余持续时间
func get_skill_duration(skill_id: int) -> float:
	return active_effects.get(skill_id, 0.0)

# 启用/禁用被动技能
func set_passive_skill(skill_id: PassiveSkill, enabled: bool) -> void:
	passive_skills[skill_id] = enabled

# 获取被动技能状态
func get_passive_skill(skill_id: PassiveSkill) -> bool:
	return passive_skills.get(skill_id, false)

# 重置所有冷却时间（用于调试或特殊情况）
func reset_all_cooldowns() -> void:
	for skill_id in active_skill_data:
		active_skill_data[skill_id]["current_cooldown"] = 0.0

# 获取技能名称
func get_skill_name(skill_id: int, skill_type: SkillType) -> String:
	if skill_type == SkillType.PASSIVE:
		match skill_id:
			PassiveSkill.SPRINT:
				return "奔跑"
			PassiveSkill.DASH_ATTACK:
				return "冲刺攻击"
			PassiveSkill.DOUBLE_JUMP:
				return "二段跳"
	else:
		# 战士技能
		if skill_id in [100, 101, 102, 103]:
			match skill_id:
				100:  # CHARGE_SLASH
					return "冲锋斩击"
				101:  # SHIELD_BLOCK
					return "盾牌格挡"
				102:  # BERSERKER
					return "狂暴"
				103:  # WAR_CRY
					return "战吼"
		# 法师技能
		elif skill_id in [200, 201, 202, 203]:
			match skill_id:
				200:  # FIREBALL
					return "火球术"
				201:  # FREEZE
					return "冰冻术"
				202:  # HEAL
					return "治疗术"
				203:  # TELEPORT
					return "传送术"
	
	return "未知技能"
