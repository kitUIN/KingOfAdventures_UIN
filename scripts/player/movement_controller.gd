class_name MovementController
extends RefCounted

# 移动相关参数
var gravity: float = 1200.0
var jump_force: float = -500.0
var speed: float = 100.0

var player_ref: CharacterBody2D

func _init(player: CharacterBody2D, gravity_val: float, jump_val: float, speed_val: float):
	player_ref = player
	gravity = gravity_val
	jump_force = jump_val
	speed = speed_val

# 处理移动物理
func handle_movement(delta: float, can_move: bool) -> float:
	# 获取输入方向
	var input_dir = Input.get_axis("ui_left", "ui_right")
	
	# 水平移动（如果允许移动）
	if can_move:
		player_ref.velocity.x = input_dir * speed
	else:
		player_ref.velocity.x = 0  # 攻击时停止水平移动
	
	# 重力处理
	if not player_ref.is_on_floor():
		player_ref.velocity.y += gravity * delta
	else:
		# 跳跃处理
		if Input.is_action_just_pressed("ui_jump") and can_move:
			player_ref.velocity.y = jump_force
	
	# 应用移动
	player_ref.move_and_slide()
	
	return input_dir

# 检查跳跃输入
func should_jump() -> bool:
	return Input.is_action_just_pressed("ui_jump") and player_ref.is_on_floor()

# 获取输入方向
func get_input_direction() -> float:
	return Input.get_axis("ui_left", "ui_right")

# 设置移动参数
func set_gravity(new_gravity: float) -> void:
	gravity = new_gravity

func set_jump_force(new_jump_force: float) -> void:
	jump_force = new_jump_force

func set_speed(new_speed: float) -> void:
	speed = new_speed
