extends Control

const FADE_TIME = 1.0
onready var black_flash = get_node("BlackFlash")
var fade_progress = 0.0
signal fade_finished # for function callback

func _ready():
	set_process(true)

func _process(delta):
	if not get_tree().get_root().is_input_disabled():
		if Input.is_action_pressed("ui_accept"):
			get_node("NewGame")._on_button_pressed()
	else:
		if fade_progress >= FADE_TIME:
			emit_signal("fade_finished")
			get_tree().get_root().set_disable_input(false)
		else:
			fade_progress += delta
			black_flash.set_modulate(Color(0.0, 0.0, 0.0, fade_progress))

func begin_fade(func_name):
	black_flash.show()
	black_flash.set_modulate(Color(0.0, 0.0, 0.0, 0.0))
	connect("fade_finished", self, func_name)

func new_game():
	get_tree().change_scene("res://scenes/levels/lvl0.tscn")
