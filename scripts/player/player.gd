extends CharacterBody2D

@export var gravity: float = 1200.0
@export var jump_force: float = -500.0
@export var speed: float = 100.0
@export var is_dual_weapon: bool = false # true表示双手武器，false表示单手武器

# 攻击相关变量
var is_attacking: bool = false
var attack_count: int = 0
var attack_sequence = [1, 1, 1, 2, 3]  # 攻击序列
var attack_combo_timer: float = 0.0
var attack_duration: float = 0.33  # 单次攻击持续时间（秒）
var attack_combo_window: float = 0.25  # 连击时间窗口（秒）

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 攻击计时器处理
	handle_attack_timers(delta)
	
	# 攻击输入处理
	if Input.is_action_just_pressed("ui_attack") and not is_attacking:
		start_attack()
	
	# 移动处理（攻击时限制移动）
	var input_dir = Input.get_axis("ui_left", "ui_right")
	if not is_attacking:
		velocity.x = input_dir * speed
	else:
		velocity.x = 0  # 攻击时停止水平移动

	# 重力
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("ui_jump") and not is_attacking:
			velocity.y = jump_force

	move_and_slide()

	# --------------------
	# 动画控制
	# --------------------
	# 攻击时不处理其他动画，攻击动画在 play_attack_animation 函数中处理
	if not is_attacking:
		var animation: String = "default"
		if not is_on_floor():
			animation = "jump"
		elif input_dir != 0:
			animation = "run"
		
		# 根据武器模式选择动画后缀
		if is_dual_weapon:
			animation = animation + "_d"
		else:
			animation = animation + "_s"
		
		anim.animation = animation
		anim.play()
	
	# 根据方向翻转（攻击时也需要翻转）
	if input_dir != 0:
		anim.flip_h = input_dir < 0


func _ready() -> void:
	hide()
	
func init(start_pos: Vector2) -> void:
	position = start_pos
	show()

# 攻击计时器处理
func handle_attack_timers(delta: float) -> void:
	if attack_combo_timer > 0:
		attack_combo_timer -= delta
		if attack_combo_timer <= 0:
			# 连击时间窗口结束，重置攻击计数
			attack_count = 0

# 开始攻击
func start_attack() -> void:
	var current_attack: int
	
	# 检查是否在空中
	if not is_on_floor():
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
	
	# 播放攻击动画
	play_attack_animation(current_attack)
	
	# 设置攻击结束计时器
	get_tree().create_timer(attack_duration).timeout.connect(_on_attack_finished)

# 播放攻击动画
func play_attack_animation(attack_type: int) -> void:
	var attack_anim = "attack_" + str(attack_type)
	if is_dual_weapon:
		attack_anim += "_d"
	else:
		attack_anim += "_s"
	anim.animation = attack_anim
	anim.play()

# 攻击结束回调
func _on_attack_finished() -> void:
	is_attacking = false
