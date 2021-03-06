extends Control

const SPEED = 15.0

onready var lbl = get_node("RichTextLabel")


func _ready():
	set_process(true)
	
	get_node("entities/Millipede").begin()
	
	Music.set_ensure_playing(preload("res://assets/sound/music/level_7.ogg"))
	Music.play(65) # start 65 seconds into song


func _process(delta):
	if Input.is_action_pressed("ui_cancel"): exit_with_fade()
	
	if lbl.get_pos().y + lbl.get_size().y < 0: exit()
	
	lbl.set_pos(lbl.get_pos() + Vector2(0, -SPEED * delta))


func exit_with_fade():
	get_node("Fade").begin_fade_out()
	get_node("Fade").connect("fade_finished", self, "exit")
	set_process(false)


func exit():
	get_tree().change_scene("res://scenes/main_menu.scn")


func _on_RichTextLabel_meta_clicked( meta ):
	OS.shell_open(meta)
