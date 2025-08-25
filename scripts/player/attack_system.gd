class_name AttackSystem
extends RefCounted

# 攻击相关信号
signal attack_started(attack_type: int)
signal attack_finished()

# 攻击相关变量
var is_attacking: bool = false
var attack_count: int = 0
var attack_sequence = [1, 1, 2, 3]  # 攻击序列
var attack_combo_timer: float = 0.0
var attack_combo_window: float = 0.25  # 连击时间窗口（秒）

# 攻击持续时间（秒）- 按照24帧/秒计算
const ATTACK_DURATIONS = {
	# 单手武器攻击持续时间
	"single_handed": {
		1: 0.292,  # 7帧 ÷ 24帧/秒
		2: 0.417,  # 10帧 ÷ 24帧/秒
		3: 0.417   # 10帧 ÷ 24帧/秒
	},
	# 双手武器攻击持续时间
	"double_handed": {
		1: 0.5,    # 12帧 ÷ 24帧/秒
		2: 0.625,  # 15帧 ÷ 24帧/秒
		3: 0.625   # 15帧 ÷ 24帧/秒
	}
}

var player_ref: CharacterBody2D
var current_attack_duration: float = 0.33  # 当前攻击的持续时间

# 伤害倍数
var damage_multipliers: Array[float] = []

func _init(player: CharacterBody2D):
	player_ref = player

# 获取当前武器类型
func get_weapon_type() -> String:
	# 使用player的weapon_mode来判断武器类型
	if player_ref.weapon_mode == 0:  # WeaponMode.SINGLE_HAND
		return "single_handed"
	else:  # WeaponMode.DUAL_HAND
		return "double_handed"

# 获取指定攻击类型的持续时间
func get_attack_duration(attack_type: int) -> float:
	var weapon_type = get_weapon_type()
	if ATTACK_DURATIONS.has(weapon_type) and ATTACK_DURATIONS[weapon_type].has(attack_type):
		return ATTACK_DURATIONS[weapon_type][attack_type]
	return 0.33  # 默认持续时间

# 攻击计时器处理
func handle_timers(delta: float) -> void:
	if attack_combo_timer > 0:
		attack_combo_timer -= delta
		if attack_combo_timer <= 0:
			# 连击时间窗口结束，重置攻击计数
			attack_count = 0

# 处理攻击输入
func handle_input() -> void:
	if Input.is_action_just_pressed("ui_attack") and not is_attacking:
		start_attack()

# 开始攻击
func start_attack() -> void:
	var current_attack: int
	
	# 检查是否在空中
	if not player_ref.is_on_floor():
		# 空中攻击固定使用序列2
		current_attack = 2
	else:
		# 地面攻击使用正常序列
		if attack_combo_timer <= 0:
			# 如果连击时间窗口已过，重置攻击计数
			attack_count = 0
		
		# 获取当前攻击类型
		current_attack = attack_sequence[attack_count % attack_sequence.size()]
		attack_count += 1
	
	# 获取当前攻击的持续时间
	current_attack_duration = get_attack_duration(current_attack)
	
	# 设置攻击状态
	is_attacking = true
	attack_combo_timer = attack_combo_window + current_attack_duration
	
	# 发出攻击开始信号
	attack_started.emit(current_attack)
	
	# 设置攻击结束计时器
	player_ref.get_tree().create_timer(current_attack_duration).timeout.connect(_on_attack_finished)

# 攻击结束回调
func _on_attack_finished() -> void:
	is_attacking = false
	attack_finished.emit()

# 检查是否可以移动（攻击时限制移动）
func can_move() -> bool:
	return not is_attacking

# 获取当前攻击持续时间
func get_current_attack_duration() -> float:
	return current_attack_duration

# 添加伤害倍数
func add_damage_multiplier(multiplier: float) -> void:
	damage_multipliers.append(multiplier)

# 移除伤害倍数
func remove_damage_multiplier(multiplier: float) -> void:
	var index = damage_multipliers.find(multiplier)
	if index != -1:
		damage_multipliers.remove_at(index)

# 获取总伤害倍数
func get_total_damage_multiplier() -> float:
	var total = 1.0
	for multiplier in damage_multipliers:
		total *= multiplier
	return total

# 清除所有伤害倍数
func clear_damage_multipliers() -> void:
	damage_multipliers.clear()
