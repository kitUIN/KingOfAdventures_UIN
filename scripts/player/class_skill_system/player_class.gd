class_name PlayerClass
extends RefCounted

# 职业枚举
enum ClassType {
	WARRIOR,    # 战士
	MAGE        # 法师
}

# 职业属性
var class_type: ClassType = ClassType.WARRIOR
var class_name_value: String = ""
var description: String = ""

# 职业基础属性加成
var hp_bonus: float = 0.0
var mana_bonus: float = 0.0
var attack_damage_bonus: float = 0.0
var magic_damage_bonus: float = 0.0
var defense_bonus: float = 0.0
var magic_resistance_bonus: float = 0.0
var speed_bonus: float = 0.0

# 职业特色技能
var active_skills: Array[String] = []

func _init(type: ClassType = ClassType.WARRIOR):
	class_type = type
	setup_class_data()

# 设置职业数据
func setup_class_data() -> void:
	match class_type:
		ClassType.WARRIOR:
			class_name_value = "战士"
			description = "近战专家，擅长物理攻击和防御"
			hp_bonus = 50.0
			mana_bonus = 10.0
			attack_damage_bonus = 20.0
			magic_damage_bonus = 5.0
			defense_bonus = 15.0
			magic_resistance_bonus = 5.0
			speed_bonus = 5.0
			active_skills = ["冲锋斩击", "盾牌格挡", "狂暴", "战吼"]
			
		ClassType.MAGE:
			class_name_value = "法师"
			description = "魔法专家，擅长远程魔法攻击"
			hp_bonus = 20.0
			mana_bonus = 50.0
			attack_damage_bonus = 5.0
			magic_damage_bonus = 25.0
			defense_bonus = 5.0
			magic_resistance_bonus = 20.0
			speed_bonus = 10.0
			active_skills = ["火球术", "冰冻术", "治疗术", "传送术"]

# 获取职业名称
func get_class_name() -> String:
	return class_name_value

# 获取职业描述
func get_description() -> String:
	return description

# 获取职业类型
func get_class_type() -> ClassType:
	return class_type

# 获取主动技能列表
func get_active_skills() -> Array[String]:
	return active_skills

# 切换职业
func change_class(new_type: ClassType) -> void:
	class_type = new_type
	setup_class_data()

# 获取所有属性加成
func get_stat_bonuses() -> Dictionary:
	return {
		"hp": hp_bonus,
		"mana": mana_bonus,
		"attack_damage": attack_damage_bonus,
		"magic_damage": magic_damage_bonus,
		"defense": defense_bonus,
		"magic_resistance": magic_resistance_bonus,
		"speed": speed_bonus
	}
