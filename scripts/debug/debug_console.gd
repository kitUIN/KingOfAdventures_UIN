class_name DebugConsole
extends Control

# 玩家引用
var player_ref: CharacterBody2D = null

# 当前选择的装备类型
var current_right_weapon_type: String = "short_sword"
var current_dual_weapon_type: String = "greatsword"
var current_hat_type: String = "helmet"
var current_clothing_type: String = "armor"

# 节点引用 - 基础控制
@onready var single_hand_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponModeGroup/WeaponModeContainer/SingleHandBtn
@onready var dual_hand_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponModeGroup/WeaponModeContainer/DualHandBtn
@onready var female_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GenderGroup/GenderContainer/FemaleBtn
@onready var male_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GenderGroup/GenderContainer/MaleBtn
@onready var close_btn = $Panel/VBoxContainer/CloseContainer/CloseBtn

# 头发按钮
@onready var hair_buttons = [
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HairGroup/HairContainer/Hair1Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HairGroup/HairContainer/Hair2Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HairGroup/HairContainer/Hair3Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HairGroup/HairContainer/Hair4Btn
]

# 眼睛按钮
@onready var eye_buttons = [
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/EyeGroup/EyeContainer/Eye1Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/EyeGroup/EyeContainer/Eye2Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/EyeGroup/EyeContainer/Eye3Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/EyeGroup/EyeContainer/Eye4Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/EyeGroup/EyeContainer/Eye5Btn
]

# 帽子按钮
@onready var helmet_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/HatGroup/HatTypeContainer/HelmetBtn
@onready var wizard_hat_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/HatGroup/HatTypeContainer/WizardHatBtn
@onready var hat_variant_buttons = [
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HatGroup/HatVariantContainer/Hat1Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HatGroup/HatVariantContainer/Hat2Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HatGroup/HatVariantContainer/Hat3Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HatGroup/HatVariantContainer/Hat4Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HatGroup/HatVariantContainer/Hat5Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/HatGroup/HatVariantContainer/Hat6Btn
]

# 衣服按钮
@onready var armor_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/ClothingGroup/ClothingTypeContainer/ArmorBtn
@onready var robe_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/ClothingGroup/ClothingTypeContainer/RobeBtn
@onready var clothing_variant_buttons = [
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/ClothingGroup/ClothingVariantContainer/Clothing1Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/ClothingGroup/ClothingVariantContainer/Clothing2Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/ClothingGroup/ClothingVariantContainer/Clothing3Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/ClothingGroup/ClothingVariantContainer/Clothing4Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/ClothingGroup/ClothingVariantContainer/Clothing5Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/ClothingGroup/ClothingVariantContainer/Clothing6Btn
]

# 左手武器按钮 (盾牌) - 6个变体
@onready var left_weapon_buttons = [
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/LeftWeaponGroup/LeftWeaponContainer/Buckler1Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/LeftWeaponGroup/LeftWeaponContainer/Buckler2Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/LeftWeaponGroup/LeftWeaponContainer/Buckler3Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/LeftWeaponGroup/LeftWeaponContainer/Buckler4Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/LeftWeaponGroup/LeftWeaponContainer/Buckler5Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/LeftWeaponGroup/LeftWeaponContainer/Buckler6Btn
]

# 右手武器类型按钮
@onready var rod_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/RightWeaponGroup/RightWeaponTypeContainer/RodBtn
@onready var short_sword_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/RightWeaponGroup/RightWeaponTypeContainer/ShortSwordBtn

# 右手武器变体按钮 - 6个变体
@onready var right_weapon_variant_buttons = [
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/RightWeaponGroup/RightWeaponVariantContainer/RightVar1Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/RightWeaponGroup/RightWeaponVariantContainer/RightVar2Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/RightWeaponGroup/RightWeaponVariantContainer/RightVar3Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/RightWeaponGroup/RightWeaponVariantContainer/RightVar4Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/RightWeaponGroup/RightWeaponVariantContainer/RightVar5Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/RightWeaponGroup/RightWeaponVariantContainer/RightVar6Btn
]

# 双手武器类型按钮
@onready var staff_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/DualWeaponGroup/DualWeaponTypeContainer/StaffBtn
@onready var greatsword_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/DualWeaponGroup/DualWeaponTypeContainer/GreatswordBtn

# 双手武器变体按钮 - 6个变体
@onready var dual_weapon_variant_buttons = [
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/DualWeaponGroup/DualWeaponVariantContainer/DualVar1Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/DualWeaponGroup/DualWeaponVariantContainer/DualVar2Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/DualWeaponGroup/DualWeaponVariantContainer/DualVar3Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/DualWeaponGroup/DualWeaponVariantContainer/DualVar4Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/DualWeaponGroup/DualWeaponVariantContainer/DualVar5Btn,
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/WeaponGroup/DualWeaponGroup/DualWeaponVariantContainer/DualVar6Btn
]

func _ready():
	# 默认隐藏控制台
	visible = false
	
	# 连接信号
	setup_signals()

# 设置玩家引用
func set_player_ref(player: CharacterBody2D):
	player_ref = player
	update_ui_state()

# 设置所有按钮信号
func setup_signals():
	# 武器模式切换
	single_hand_btn.pressed.connect(_on_single_hand_pressed)
	dual_hand_btn.pressed.connect(_on_dual_hand_pressed)
	
	# 性别切换
	female_btn.pressed.connect(_on_female_pressed)
	male_btn.pressed.connect(_on_male_pressed)
	
	# 头发样式
	for i in range(hair_buttons.size()):
		hair_buttons[i].pressed.connect(_on_hair_style_pressed.bind(i + 1))
	
	# 眼睛样式
	for i in range(eye_buttons.size()):
		eye_buttons[i].pressed.connect(_on_eye_style_pressed.bind(i + 1))
	
	# 帽子类型
	helmet_btn.pressed.connect(_on_hat_type_pressed.bind("helmet"))
	wizard_hat_btn.pressed.connect(_on_hat_type_pressed.bind("wizard_hat"))
	
	# 帽子变体
	for i in range(hat_variant_buttons.size()):
		hat_variant_buttons[i].pressed.connect(_on_hat_variant_pressed.bind(i + 1))
	
	# 衣服类型
	armor_btn.pressed.connect(_on_clothing_type_pressed.bind("armor"))
	robe_btn.pressed.connect(_on_clothing_type_pressed.bind("robe"))
	
	# 衣服变体
	for i in range(clothing_variant_buttons.size()):
		clothing_variant_buttons[i].pressed.connect(_on_clothing_variant_pressed.bind(i + 1))
	
	# 左手武器 (盾牌) - 6个变体
	for i in range(left_weapon_buttons.size()):
		left_weapon_buttons[i].pressed.connect(_on_left_weapon_pressed.bind(i + 1))
	
	# 右手武器类型
	rod_btn.pressed.connect(_on_right_weapon_type_pressed.bind("rod"))
	short_sword_btn.pressed.connect(_on_right_weapon_type_pressed.bind("short_sword"))
	
	# 右手武器变体 - 6个变体
	for i in range(right_weapon_variant_buttons.size()):
		right_weapon_variant_buttons[i].pressed.connect(_on_right_weapon_variant_pressed.bind(i + 1))
	
	# 双手武器类型
	staff_btn.pressed.connect(_on_dual_weapon_type_pressed.bind("staff"))
	greatsword_btn.pressed.connect(_on_dual_weapon_type_pressed.bind("greatsword"))
	
	# 双手武器变体 - 6个变体
	for i in range(dual_weapon_variant_buttons.size()):
		dual_weapon_variant_buttons[i].pressed.connect(_on_dual_weapon_variant_pressed.bind(i + 1))
	
	# 关闭按钮
	close_btn.pressed.connect(_on_close_pressed)

# 更新UI状态以反映当前玩家设置
func update_ui_state():
	if not player_ref:
		return
	
	# 更新武器模式按钮状态
	var weapon_mode = player_ref.weapon_mode
	single_hand_btn.button_pressed = (weapon_mode == 0)  # SINGLE_HAND
	dual_hand_btn.button_pressed = (weapon_mode == 1)   # DUAL_HAND
	
	# 更新性别按钮状态
	var gender = player_ref.gender
	female_btn.button_pressed = (gender == 0)  # FEMALE
	male_btn.button_pressed = (gender == 1)    # MALE
	
	# 更新头发样式按钮状态
	update_hair_buttons_state()
	
	# 更新眼睛样式按钮状态
	update_eye_buttons_state()
	
	# 更新帽子选择状态
	update_hat_buttons_state()
	
	# 更新衣服选择状态
	update_clothing_buttons_state()
	
	# 更新武器选择状态和禁用逻辑
	update_weapon_buttons_state()
	update_weapon_disable_state()

# 状态更新函数
func update_hair_buttons_state():
	if not player_ref:
		return
	
	# 重置所有头发按钮
	for btn in hair_buttons:
		btn.button_pressed = false
	
	# 根据当前头发样式设置按钮状态
	var current_style = player_ref.hair_style
	if current_style >= 1 and current_style <= hair_buttons.size():
		hair_buttons[current_style - 1].button_pressed = true

func update_eye_buttons_state():
	if not player_ref:
		return
	
	# 重置所有眼睛按钮
	for btn in eye_buttons:
		btn.button_pressed = false
	
	# 根据当前眼睛类型设置按钮状态
	var current_eye = player_ref.eye_type
	if current_eye.begins_with("eye_"):
		var eye_num = current_eye.replace("eye_", "").to_int()
		if eye_num >= 1 and eye_num <= eye_buttons.size():
			eye_buttons[eye_num - 1].button_pressed = true

func update_hat_buttons_state():
	if not player_ref:
		return
	
	# 重置所有帽子按钮
	helmet_btn.button_pressed = false
	wizard_hat_btn.button_pressed = false
	for btn in hat_variant_buttons:
		btn.button_pressed = false
	
	# 根据当前帽子设置按钮状态
	var current_hat = player_ref.hat_type
	if current_hat.begins_with("helmet_"):
		current_hat_type = "helmet"
		helmet_btn.button_pressed = true
		var variant = current_hat.replace("helmet_", "").to_int()
		if variant >= 1 and variant <= hat_variant_buttons.size():
			hat_variant_buttons[variant - 1].button_pressed = true
	elif current_hat.begins_with("wizard_hat_"):
		current_hat_type = "wizard_hat"
		wizard_hat_btn.button_pressed = true
		var variant = current_hat.replace("wizard_hat_", "").to_int()
		if variant >= 1 and variant <= hat_variant_buttons.size():
			hat_variant_buttons[variant - 1].button_pressed = true

func update_clothing_buttons_state():
	if not player_ref:
		return
	
	# 重置所有衣服按钮
	armor_btn.button_pressed = false
	robe_btn.button_pressed = false
	for btn in clothing_variant_buttons:
		btn.button_pressed = false
	
	# 根据当前衣服设置按钮状态
	var current_clothing = player_ref.clothing_type
	if current_clothing.begins_with("armor_"):
		current_clothing_type = "armor"
		armor_btn.button_pressed = true
		var variant = current_clothing.replace("armor_", "").to_int()
		if variant >= 1 and variant <= clothing_variant_buttons.size():
			clothing_variant_buttons[variant - 1].button_pressed = true
	elif current_clothing.begins_with("robe_"):
		current_clothing_type = "robe"
		robe_btn.button_pressed = true
		var variant = current_clothing.replace("robe_", "").to_int()
		if variant >= 1 and variant <= clothing_variant_buttons.size():
			clothing_variant_buttons[variant - 1].button_pressed = true

func update_weapon_buttons_state():
	if not player_ref:
		return
	
	# 重置所有武器按钮
	for btn in left_weapon_buttons:
		btn.button_pressed = false
	rod_btn.button_pressed = false
	short_sword_btn.button_pressed = false
	for btn in right_weapon_variant_buttons:
		btn.button_pressed = false
	staff_btn.button_pressed = false
	greatsword_btn.button_pressed = false
	for btn in dual_weapon_variant_buttons:
		btn.button_pressed = false
	
	# 左手武器状态
	var current_left = player_ref.left_hand_weapon
	if current_left.begins_with("buckler_"):
		var variant = current_left.replace("buckler_", "").to_int()
		if variant >= 1 and variant <= left_weapon_buttons.size():
			left_weapon_buttons[variant - 1].button_pressed = true
	
	# 右手武器状态
	var current_right = player_ref.right_hand_weapon
	if current_right.begins_with("rod_"):
		current_right_weapon_type = "rod"
		rod_btn.button_pressed = true
		var variant = current_right.replace("rod_", "").to_int()
		if variant >= 1 and variant <= right_weapon_variant_buttons.size():
			right_weapon_variant_buttons[variant - 1].button_pressed = true
	elif current_right.begins_with("short_sword_"):
		current_right_weapon_type = "short_sword"
		short_sword_btn.button_pressed = true
		var variant = current_right.replace("short_sword_", "").to_int()
		if variant >= 1 and variant <= right_weapon_variant_buttons.size():
			right_weapon_variant_buttons[variant - 1].button_pressed = true
	
	# 双手武器状态
	var current_dual = player_ref.dual_hand_weapon
	if current_dual.begins_with("staff_"):
		current_dual_weapon_type = "staff"
		staff_btn.button_pressed = true
		var variant = current_dual.replace("staff_", "").to_int()
		if variant >= 1 and variant <= dual_weapon_variant_buttons.size():
			dual_weapon_variant_buttons[variant - 1].button_pressed = true
	elif current_dual.begins_with("greatsword_"):
		current_dual_weapon_type = "greatsword"
		greatsword_btn.button_pressed = true
		var variant = current_dual.replace("greatsword_", "").to_int()
		if variant >= 1 and variant <= dual_weapon_variant_buttons.size():
			dual_weapon_variant_buttons[variant - 1].button_pressed = true

func update_weapon_disable_state():
	if not player_ref:
		return
	
	var is_dual_hand = player_ref.weapon_mode == 1  # DUAL_HAND
	
	# 根据武器模式禁用/启用相应的武器控制
	# 单手模式：禁用双手武器控制
	# 双手模式：禁用单手武器控制
	
	# 左手武器组
	for btn in left_weapon_buttons:
		btn.disabled = is_dual_hand
	
	# 右手武器组
	rod_btn.disabled = is_dual_hand
	short_sword_btn.disabled = is_dual_hand
	for btn in right_weapon_variant_buttons:
		btn.disabled = is_dual_hand
	
	# 双手武器组
	staff_btn.disabled = not is_dual_hand
	greatsword_btn.disabled = not is_dual_hand
	for btn in dual_weapon_variant_buttons:
		btn.disabled = not is_dual_hand

# 武器模式切换
func _on_single_hand_pressed():
	if player_ref:
		player_ref.set_weapon_mode(0)  # SINGLE_HAND
		update_weapon_disable_state()  # 立即更新禁用状态
		print("切换到单手武器模式")

func _on_dual_hand_pressed():
	if player_ref:
		player_ref.set_weapon_mode(1)  # DUAL_HAND
		update_weapon_disable_state()  # 立即更新禁用状态
		print("切换到双手武器模式")

# 性别切换
func _on_female_pressed():
	if player_ref:
		player_ref.set_gender(0)  # FEMALE
		print("切换到女性")

func _on_male_pressed():
	if player_ref:
		player_ref.set_gender(1)  # MALE
		print("切换到男性")

# 头发样式切换
func _on_hair_style_pressed(style: int):
	if player_ref:
		player_ref.set_hair_style(style)
		print("切换头发样式到: " + str(style))

# 眼睛样式切换
func _on_eye_style_pressed(style: int):
	if player_ref:
		var eye_type = "eye_" + str(style)
		player_ref.set_eye_type(eye_type)
		print("切换眼睛样式到: " + eye_type)

# 帽子类型切换
func _on_hat_type_pressed(hat_type: String):
	current_hat_type = hat_type
	# 更新按钮状态
	helmet_btn.button_pressed = (hat_type == "helmet")
	wizard_hat_btn.button_pressed = (hat_type == "wizard_hat")
	# 清除变体选择
	for btn in hat_variant_buttons:
		btn.button_pressed = false
	print("选择帽子类型: " + hat_type)

# 帽子变体切换
func _on_hat_variant_pressed(variant: int):
	if player_ref:
		var hat_name = current_hat_type + "_" + str(variant)
		player_ref.set_hat_type(hat_name)
		# 更新变体按钮状态
		for i in range(hat_variant_buttons.size()):
			hat_variant_buttons[i].button_pressed = (i == variant - 1)
		print("切换帽子到: " + hat_name)

# 衣服类型切换
func _on_clothing_type_pressed(clothing_type: String):
	current_clothing_type = clothing_type
	# 更新按钮状态
	armor_btn.button_pressed = (clothing_type == "armor")
	robe_btn.button_pressed = (clothing_type == "robe")
	# 清除变体选择
	for btn in clothing_variant_buttons:
		btn.button_pressed = false
	print("选择衣服类型: " + clothing_type)

# 衣服变体切换
func _on_clothing_variant_pressed(variant: int):
	if player_ref:
		var clothing_name = current_clothing_type + "_" + str(variant)
		player_ref.set_clothing_type(clothing_name)
		# 更新变体按钮状态
		for i in range(clothing_variant_buttons.size()):
			clothing_variant_buttons[i].button_pressed = (i == variant - 1)
		print("切换衣服到: " + clothing_name)

# 左手武器切换 (盾牌)
func _on_left_weapon_pressed(variant: int):
	if player_ref:
		var weapon_name = "buckler_" + str(variant)
		player_ref.set_left_weapon(weapon_name)
		# 更新按钮状态
		for i in range(left_weapon_buttons.size()):
			left_weapon_buttons[i].button_pressed = (i == variant - 1)
		print("切换左手武器到: " + weapon_name)

# 右手武器类型切换
func _on_right_weapon_type_pressed(weapon_type: String):
	current_right_weapon_type = weapon_type
	# 更新按钮状态
	rod_btn.button_pressed = (weapon_type == "rod")
	short_sword_btn.button_pressed = (weapon_type == "short_sword")
	# 清除变体选择
	for btn in right_weapon_variant_buttons:
		btn.button_pressed = false
	print("选择右手武器类型: " + weapon_type)

# 右手武器变体切换
func _on_right_weapon_variant_pressed(variant: int):
	if player_ref:
		var weapon_name = current_right_weapon_type + "_" + str(variant)
		player_ref.set_right_weapon(weapon_name)
		# 更新变体按钮状态
		for i in range(right_weapon_variant_buttons.size()):
			right_weapon_variant_buttons[i].button_pressed = (i == variant - 1)
		print("切换右手武器到: " + weapon_name)

# 双手武器类型切换
func _on_dual_weapon_type_pressed(weapon_type: String):
	current_dual_weapon_type = weapon_type
	# 更新按钮状态
	staff_btn.button_pressed = (weapon_type == "staff")
	greatsword_btn.button_pressed = (weapon_type == "greatsword")
	# 清除变体选择
	for btn in dual_weapon_variant_buttons:
		btn.button_pressed = false
	print("选择双手武器类型: " + weapon_type)

# 双手武器变体切换
func _on_dual_weapon_variant_pressed(variant: int):
	if player_ref:
		var weapon_name = current_dual_weapon_type + "_" + str(variant)
		player_ref.set_dual_weapon(weapon_name)
		# 更新变体按钮状态
		for i in range(dual_weapon_variant_buttons.size()):
			dual_weapon_variant_buttons[i].button_pressed = (i == variant - 1)
		print("切换双手武器到: " + weapon_name)

# 关闭控制台
func _on_close_pressed():
	hide()

# 显示/隐藏控制台
func toggle_console():
	visible = not visible
	if visible:
		update_ui_state()