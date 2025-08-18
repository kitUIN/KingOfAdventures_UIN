extends Node


func new_game():
	$MapLoader.init()
	$Player.init($StartPosition.position)
	# 设置调试控制台的玩家引用
	$DebugConsole.set_player_ref($Player)
	#$Player.set_weapon_mode($Player.WeaponMode.DUAL_HAND)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# 处理调试控制台输入
func _input(event):
	# 按ESC键切换调试控制台
	if event.is_action_pressed("ui_cancel"):
		$DebugConsole.toggle_console()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print($Player.position)
	pass
