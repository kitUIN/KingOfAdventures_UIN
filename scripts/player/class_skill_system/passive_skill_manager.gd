class_name PassiveSkillManager
extends RefCounted

# 引用技能系统
var skill_system
var movement_controller
var player_ref: CharacterBody2D

# 奔跑系统相关
var is_sprinting: bool = false
var sprint_speed_multiplier: float = 2.0
var sprint_input_timer: float = 0.0
var double_tap_time: float = 0.3  # 双击检测时间
var last_input_direction: float = 0.0

# 二段跳系统相关
var has_double_jumped: bool = false
var double_jump_force: float = -400.0

# 冲刺攻击相关
var dash_attack_enabled: bool = false
var dash_attack_damage_multiplier: float = 1.5

# 输入跟踪
var previous_input: float = 0.0

func _init(skill_sys, movement_ctrl, player: CharacterBody2D):
	skill_system = skill_sys
	movement_controller = movement_ctrl
	player_ref = player

# 更新被动技能
func update_passive_skills(delta: float, input_dir: float) -> void:
	# 更新奔跑系统
	update_sprint_system(delta, input_dir)
	
	# 检查二段跳
	check_double_jump()
	
	# 重置二段跳当在地面时
	if player_ref.is_on_floor():
		has_double_jumped = false

# 更新奔跑系统
func update_sprint_system(delta: float, input_dir: float) -> void:
	if not skill_system.get_passive_skill(0):  # SPRINT
		return
	
	# 检测双击前进键
	if input_dir != 0:
		# 检查是否是新的输入方向
		if abs(input_dir - previous_input) > 0.1 and previous_input == 0:
			# 检查是否在双击时间窗口内
			if sprint_input_timer < double_tap_time and abs(input_dir - last_input_direction) < 0.1:
				# 双击检测成功，开始奔跑
				is_sprinting = true
				print("开始奔跑!")
			else:
				# 重置计时器，记录第一次按键
				sprint_input_timer = 0.0
				last_input_direction = input_dir
		
		# 如果正在奔跑且方向改变，停止奔跑
		if is_sprinting and abs(input_dir - last_input_direction) > 0.1:
			is_sprinting = false
			print("停止奔跑 - 方向改变")
	else:
		# 没有输入时停止奔跑
		if is_sprinting:
			is_sprinting = false
			print("停止奔跑 - 停止移动")
	
	# 更新双击计时器
	if sprint_input_timer < double_tap_time:
		sprint_input_timer += delta
	
	# 更新上一帧输入
	previous_input = input_dir
	
	# 应用奔跑速度加成
	if is_sprinting:
		# 检查是否激活冲刺攻击
		if skill_system.get_passive_skill(1):  # DASH_ATTACK
			dash_attack_enabled = true

# 检查二段跳
func check_double_jump() -> void:
	if not skill_system.get_passive_skill(2):  # DOUBLE_JUMP
		return
	
	# 如果在空中且还没有二段跳且按下跳跃键
	if not player_ref.is_on_floor() and not has_double_jumped and Input.is_action_just_pressed("ui_jump"):
		player_ref.velocity.y = double_jump_force
		has_double_jumped = true
		print("二段跳!")

# 获取当前速度倍数（用于移动控制器）
func get_speed_multiplier() -> float:
	if is_sprinting:
		return sprint_speed_multiplier
	return 1.0

# 获取是否正在奔跑
func get_is_sprinting() -> bool:
	return is_sprinting

# 获取是否可以进行冲刺攻击
func can_dash_attack() -> bool:
	return dash_attack_enabled and is_sprinting

# 执行冲刺攻击
func perform_dash_attack() -> void:
	if can_dash_attack():
		dash_attack_enabled = false
		print("冲刺攻击!")
		# 这里可以触发特殊的攻击效果

# 获取冲刺攻击伤害倍数
func get_dash_attack_multiplier() -> float:
	if can_dash_attack():
		return dash_attack_damage_multiplier
	return 1.0

# 重置奔跑状态（用于特殊情况）
func reset_sprint() -> void:
	is_sprinting = false
	sprint_input_timer = double_tap_time
	dash_attack_enabled = false

# 设置奔跑参数
func set_sprint_multiplier(multiplier: float) -> void:
	sprint_speed_multiplier = multiplier

func set_double_tap_time(time: float) -> void:
	double_tap_time = time

func set_double_jump_force(force: float) -> void:
	double_jump_force = force

func set_dash_attack_multiplier(multiplier: float) -> void:
	dash_attack_damage_multiplier = multiplier
