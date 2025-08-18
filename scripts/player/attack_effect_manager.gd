class_name AttackEffectManager
extends RefCounted

# 攻击特效信号
signal effect_started(attack_type: int)
signal effect_finished(attack_type: int)

# 特效资源路径
const ATTACK_EFFECT_PATHS = {
	1: "res://screen/player/attack/attack_1_effect.tscn",
	2: "res://screen/player/attack/attack_2_effect.tscn", 
	3: "res://screen/player/attack/attack_3_effect.tscn"
}

# 特效持续时间（秒）
const EFFECT_DURATIONS = {
	1: 0.3,  # 攻击1特效持续时间
	2: 0.3,  # 攻击2特效持续时间
	3: 0.5   # 攻击3特效持续时间
}

# 特效位置偏移（相对于玩家位置）
const EFFECT_POSITIONS = {
	1: Vector2(-30, 0),   # 攻击1特效位置
	2: Vector2(-10, -5), # 攻击2特效位置（空中攻击，稍微靠上）
	3: Vector2(-30, 0)    # 攻击3特效位置（连击攻击，稍远一些）
}

var player_ref: CharacterBody2D
var current_effects: Dictionary = {}

func _init(player: CharacterBody2D):
	player_ref = player

# 播放攻击特效
func play_attack_effect(attack_type: int) -> void:
	# 如果该类型的特效已经在播放，先停止它
	if current_effects.has(attack_type):
		stop_attack_effect(attack_type)
	
	# 检查特效资源是否存在
	if not ATTACK_EFFECT_PATHS.has(attack_type):
		print("警告：未找到攻击类型 " + str(attack_type) + " 的特效资源")
		return
	
	var effect_scene_path = ATTACK_EFFECT_PATHS[attack_type]
	var effect_scene = load(effect_scene_path)
	
	if effect_scene == null:
		print("警告：无法加载特效场景: " + effect_scene_path)
		return
	
	# 创建特效实例
	var effect_instance = effect_scene.instantiate()
	
	# 添加到玩家节点
	player_ref.add_child(effect_instance)
	
	# 获取玩家朝向信息
	var body_anim = player_ref.body_node.get_node("AnimatedSprite2D")
	var is_facing_left = not (body_anim and body_anim.flip_h)
	
	# 获取该攻击类型的基础位置
	var base_position = EFFECT_POSITIONS.get(attack_type, Vector2(0, 0))
	
	# 根据玩家朝向设置特效位置和翻转
	if is_facing_left:
		# 面向左时，特效位置需要镜像调整
		effect_instance.position = Vector2(-base_position.x, base_position.y)  # X轴镜像
		effect_instance.scale.x = -1  # 水平翻转
	else:
		# 面向右时，使用默认位置
		effect_instance.position = base_position
		effect_instance.scale.x = 1
	
	# 保存特效引用
	current_effects[attack_type] = effect_instance
	
	# 发出特效开始信号
	effect_started.emit(attack_type)
	
	# 调试信息
	print("播放攻击特效 ", attack_type, " 朝向: ", "左" if is_facing_left else "右", " 位置: ", effect_instance.position)
	
	# 设置特效持续时间
	var duration = EFFECT_DURATIONS.get(attack_type, 0.33)
	var timer = player_ref.get_tree().create_timer(duration)
	timer.timeout.connect(_on_effect_finished.bind(attack_type))

# 停止攻击特效
func stop_attack_effect(attack_type: int) -> void:
	if current_effects.has(attack_type):
		var effect = current_effects[attack_type]
		if effect and is_instance_valid(effect):
			effect.queue_free()
		current_effects.erase(attack_type)

# 特效结束回调
func _on_effect_finished(attack_type: int) -> void:
	stop_attack_effect(attack_type)
	effect_finished.emit(attack_type)

# 停止所有特效
func stop_all_effects() -> void:
	for attack_type in current_effects.keys():
		stop_attack_effect(attack_type)

# 检查特效是否正在播放
func is_effect_playing(attack_type: int) -> bool:
	return current_effects.has(attack_type) and is_instance_valid(current_effects[attack_type])

# 获取当前播放的特效数量
func get_active_effects_count() -> int:
	var count = 0
	for attack_type in current_effects.keys():
		if is_instance_valid(current_effects[attack_type]):
			count += 1
	return count
