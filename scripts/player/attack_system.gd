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
var attack_duration: float = 0.33  # 单次攻击持续时间（秒）
var attack_combo_window: float = 0.25  # 连击时间窗口（秒）

var player_ref: CharacterBody2D

func _init(player: CharacterBody2D):
	player_ref = player

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
	
	# 设置攻击状态
	is_attacking = true
	attack_combo_timer = attack_combo_window + attack_duration
	
	# 发出攻击开始信号
	attack_started.emit(current_attack)
	
	# 设置攻击结束计时器
	player_ref.get_tree().create_timer(attack_duration).timeout.connect(_on_attack_finished)

# 攻击结束回调
func _on_attack_finished() -> void:
	is_attacking = false
	attack_finished.emit()

# 检查是否可以移动（攻击时限制移动）
func can_move() -> bool:
	return not is_attacking
