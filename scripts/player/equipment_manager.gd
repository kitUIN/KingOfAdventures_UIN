class_name EquipmentManager
extends RefCounted

# 使用外部枚举定义（避免重复定义）

# 装备信号
signal equipment_loaded(equipment_type: String, equipment_name: String)
signal equipment_mode_changed(mode: int)

# 装备配置
var hair_type: String = "f_hear_1"
var eye_type: String = "eye_1"
var hat_type: String = "helmet_1"
var clothing_type: String = "armor_1"
var left_hand_weapon: String = "buckler_1"
var right_hand_weapon: String = "short_sword_1"
var dual_hand_weapon: String = "greatsword_1"
var weapon_mode: int = 0  # SINGLE_HAND = 0

# 节点引用
var hear_node: Node2D
var eye_node: Node2D
var hat_node: Node2D
var clothing_node: Node2D
var left_hand_node: Node2D
var right_hand_node: Node2D
var dual_hand_node: Node2D

# 场景和动画引用
var hair_scene: Node2D = null
var hair_anim: AnimatedSprite2D = null
var eye_scene: Node2D = null
var eye_anim: AnimatedSprite2D = null
var hat_scene: Node2D = null
var hat_anim: AnimatedSprite2D = null
var clothing_scene: Node2D = null
var clothing_anim: AnimatedSprite2D = null
var left_weapon_scene: Node2D = null
var left_weapon_anim: AnimatedSprite2D = null
var right_weapon_scene: Node2D = null
var right_weapon_anim: AnimatedSprite2D = null
var dual_weapon_scene: Node2D = null
var dual_weapon_anim: AnimatedSprite2D = null

func _init(hear: Node2D, eye: Node2D, hat: Node2D, clothing: Node2D, left_hand: Node2D, right_hand: Node2D, dual_hand: Node2D):
	hear_node = hear
	eye_node = eye
	hat_node = hat
	clothing_node = clothing
	left_hand_node = left_hand
	right_hand_node = right_hand
	dual_hand_node = dual_hand

# 初始化所有装备
func initialize_equipment() -> void:
	load_hair_scene()
	load_eye_scene()
	load_hat_scene()
	load_clothing_scene()
	load_weapons()
	update_weapon_mode()

# 加载头发场景
func load_hair_scene() -> void:
	# 如果已有头发场景，先移除
	if hair_scene != null:
		hair_scene.queue_free()
		hair_scene = null
		hair_anim = null
	
	# 构建头发场景路径
	var hair_path = "res://screen/player/f_hear/" + hair_type + ".tscn"
	
	var scene = load_scene(hair_path, "头发")
	if scene != null:
		hair_scene = scene
		hear_node.add_child(hair_scene)
		hair_anim = hair_scene.get_node("AnimatedSprite2D")
		equipment_loaded.emit("hair", hair_type)

# 加载眼睛场景
func load_eye_scene() -> void:
	# 如果已有眼睛场景，先移除
	if eye_scene != null:
		eye_scene.queue_free()
		eye_scene = null
		eye_anim = null
	
	# 构建眼睛场景路径
	var eye_path = "res://screen/player/eye/" + eye_type + ".tscn"
	
	var scene = load_scene(eye_path, "眼睛")
	if scene != null:
		eye_scene = scene
		eye_node.add_child(eye_scene)
		eye_anim = eye_scene.get_node("AnimatedSprite2D")
		equipment_loaded.emit("eye", eye_type)

# 加载帽子场景
func load_hat_scene() -> void:
	# 如果已有帽子场景，先移除
	if hat_scene != null:
		hat_scene.queue_free()
		hat_scene = null
		hat_anim = null
	
	if hat_type.is_empty():
		return
	
	# 构建帽子场景路径
	var hat_path = "res://screen/equipment/" + get_equipment_folder(hat_type) + "/" + hat_type + ".tscn"
	
	var scene = load_scene(hat_path, "帽子")
	if scene != null:
		hat_scene = scene
		hat_node.add_child(hat_scene)
		hat_anim = hat_scene.get_node("AnimatedSprite2D")
		equipment_loaded.emit("hat", hat_type)

# 加载衣服场景
func load_clothing_scene() -> void:
	# 如果已有衣服场景，先移除
	if clothing_scene != null:
		clothing_scene.queue_free()
		clothing_scene = null
		clothing_anim = null
	
	if clothing_type.is_empty():
		return
	
	# 构建衣服场景路径
	var clothing_path = "res://screen/equipment/" + get_equipment_folder(clothing_type) + "/" + clothing_type + ".tscn"
	
	var scene = load_scene(clothing_path, "衣服")
	if scene != null:
		clothing_scene = scene
		clothing_node.add_child(clothing_scene)
		clothing_anim = clothing_scene.get_node("AnimatedSprite2D")
		equipment_loaded.emit("clothing", clothing_type)

# 加载所有武器
func load_weapons() -> void:
	load_left_weapon()
	load_right_weapon()
	load_dual_weapon()

# 加载左手武器
func load_left_weapon() -> void:
	# 清理现有武器
	cleanup_weapon(left_weapon_scene)
	left_weapon_scene = null
	left_weapon_anim = null
	
	if left_hand_weapon.is_empty():
		return
	
	# 构建武器路径
	var weapon_path = "res://screen/equipment/" + get_equipment_folder(left_hand_weapon) + "/" + left_hand_weapon + ".tscn"
	
	var scene = load_scene(weapon_path, "左手武器")
	if scene != null:
		left_weapon_scene = scene
		left_hand_node.add_child(left_weapon_scene)
		left_weapon_anim = left_weapon_scene.get_node("AnimatedSprite2D")
		equipment_loaded.emit("left_weapon", left_hand_weapon)

# 加载右手武器
func load_right_weapon() -> void:
	# 清理现有武器
	cleanup_weapon(right_weapon_scene)
	right_weapon_scene = null
	right_weapon_anim = null
	
	if right_hand_weapon.is_empty():
		return
	
	# 构建武器路径
	var weapon_path = "res://screen/equipment/" + get_equipment_folder(right_hand_weapon) + "/" + right_hand_weapon + ".tscn"
	
	var scene = load_scene(weapon_path, "右手武器")
	if scene != null:
		right_weapon_scene = scene
		right_hand_node.add_child(right_weapon_scene)
		right_weapon_anim = right_weapon_scene.get_node("AnimatedSprite2D")
		equipment_loaded.emit("right_weapon", right_hand_weapon)

# 加载双手武器
func load_dual_weapon() -> void:
	# 清理现有武器
	cleanup_weapon(dual_weapon_scene)
	dual_weapon_scene = null
	dual_weapon_anim = null
	
	if dual_hand_weapon.is_empty():
		return
	
	# 构建武器路径
	var weapon_path = "res://screen/equipment/" + get_equipment_folder(dual_hand_weapon) + "/" + dual_hand_weapon + ".tscn"
	
	var scene = load_scene(weapon_path, "双手武器")
	if scene != null:
		dual_weapon_scene = scene
		dual_hand_node.add_child(dual_weapon_scene)
		dual_weapon_anim = dual_weapon_scene.get_node("AnimatedSprite2D")
		equipment_loaded.emit("dual_weapon", dual_hand_weapon)

# 通用场景加载函数
func load_scene(scene_path: String, scene_name: String) -> Node2D:
	# 检查文件是否存在
	if not FileAccess.file_exists(scene_path):
		print("警告：" + scene_name + "场景文件不存在: " + scene_path)
		return null
	
	# 加载场景
	var scene_resource = load(scene_path)
	if scene_resource == null:
		print("错误：无法加载" + scene_name + "场景: " + scene_path)
		return null
	
	# 实例化场景
	var scene = scene_resource.instantiate()
	if scene == null:
		print("错误：无法实例化" + scene_name + "场景")
		return null
	
	print("成功加载" + scene_name + ": " + scene_path)
	return scene

# 清理武器场景
func cleanup_weapon(weapon_scene: Node2D) -> void:
	if weapon_scene != null:
		weapon_scene.queue_free()

# 根据装备名称获取文件夹名称
func get_equipment_folder(equipment_name: String) -> String:
	# 帽子类型
	if equipment_name.begins_with("helmet"):
		return "hat/helmet"
	elif equipment_name.begins_with("wizard_hat"):
		return "hat/wizard_hat"
	# 衣服类型
	elif equipment_name.begins_with("armor"):
		return "clothing/armor"
	elif equipment_name.begins_with("robe"):
		return "clothing/robe"
	# 武器类型
	elif equipment_name.begins_with("buckler"):
		return "left_hand/buckler"
	elif equipment_name.begins_with("short_sword"):
		return "right_hand/short_sword"
	elif equipment_name.begins_with("rod"):
		return "right_hand/rod"
	elif equipment_name.begins_with("greatsword"):
		return "double_hand/greatsword"
	elif equipment_name.begins_with("staff"):
		return "double_hand/staff"
	else:
		print("警告：未知的装备类型: " + equipment_name)
		return "unknown"

# 更新武器模式（显示/隐藏对应武器）
func update_weapon_mode() -> void:
	# 根据武器模式决定显示哪些武器
	if weapon_mode == 0:  # SINGLE_HAND = 0
		# 单手模式：显示左右手武器，隐藏双手武器
		left_hand_node.visible = true
		right_hand_node.visible = true
		dual_hand_node.visible = false
	else:
		# 双手模式：隐藏左右手武器，显示双手武器
		left_hand_node.visible = false
		right_hand_node.visible = false
		dual_hand_node.visible = true
	
	equipment_mode_changed.emit(weapon_mode)

# 设置器方法
func set_hair_type(new_hair_type: String) -> void:
	hair_type = new_hair_type
	load_hair_scene()

func set_eye_type(new_eye_type: String) -> void:
	eye_type = new_eye_type
	load_eye_scene()

func set_hat_type(new_hat_type: String) -> void:
	hat_type = new_hat_type
	load_hat_scene()

func set_clothing_type(new_clothing_type: String) -> void:
	clothing_type = new_clothing_type
	load_clothing_scene()

func set_weapon_mode(new_mode: int) -> void:
	weapon_mode = new_mode
	update_weapon_mode()

func set_left_weapon(weapon_name: String) -> void:
	left_hand_weapon = weapon_name
	load_left_weapon()

func set_right_weapon(weapon_name: String) -> void:
	right_hand_weapon = weapon_name
	load_right_weapon()

func set_dual_weapon(weapon_name: String) -> void:
	dual_hand_weapon = weapon_name
	load_dual_weapon()

# 获取器方法
func get_hair_animation() -> AnimatedSprite2D:
	return hair_anim

func get_eye_animation() -> AnimatedSprite2D:
	return eye_anim

func get_hat_animation() -> AnimatedSprite2D:
	return hat_anim

func get_clothing_animation() -> AnimatedSprite2D:
	return clothing_anim

func get_weapon_animations() -> Array[AnimatedSprite2D]:
	return [left_weapon_anim, right_weapon_anim, dual_weapon_anim]

func get_weapon_mode() -> int:
	return weapon_mode
