tool
extends Node2D

signal rail_finished

const Y_MOTION = -50 # Local y position change in pixels each frame
const DIST_TO_BEGIN_LERP = 50
const INTERPOLATE_SPEED = 1

#export var max_x = 256 # Max x distance rail can travel from origin before stopping
export(int) var travel_y = 200 # The y distance the rail will travel before stopping (relative)
onready var starting_y = get_pos().y


func stop():
	set_process(false)


func _process(delta):
	if get_tree().is_editor_hint():
		update()
		return
	else:
	
	#	if get_pos().x >= max_x or get_pos().x <= -max_x or get_pos().y >= max_y or get_pos().y <= -max_y:
		if get_pos().y <= -travel_y: # If the rail has travelled past the distance of travel_y ...
			emit_signal("rail_finished")
			set_process(false) # Block processing
		
		# How many units into DIST_TO_BEGIN_LERP is the player? values: -inf thru DIST_TO_BEGIN_LERP
	#	var progress = -(starting_y + get_pos().y) + (-travel_y + DIST_TO_BEGIN_LERP)
	#	if progress >= 0:
	#		var interpolation = progress / DIST_TO_BEGIN_LERP # Get progress as num from 0 to 1
	#		set_pos(get_pos() + Vector2(0, Y_MOTION - interpolation*Y_MOTION*INTERPOLATE_SPEED) * delta)
	#	else: # Not ready to interpolate
	#		set_pos(get_pos() + Vector2(0, Y_MOTION) * delta)
	
		set_pos(get_pos() + Vector2(0, Y_MOTION) * delta)


func _ready():
	set_process(true)
	
	# Load player at checkpoints
	if not get_tree().is_editor_hint():
		if get_node("/root/GameData").data.current_section > 0: # We need to load at a checkpoint
			print(get_node("/root/GameData").data.current_section)
			for checkpoint in get_tree().get_nodes_in_group("Checkpoint"):
				print(get_node("/root/GameData").data.current_section)
				if checkpoint.section_index == get_node("/root/GameData").data.current_section: # We found the checkpoint we need to be at ...
					if checkpoint.easy_mode_only and get_node("/root/GameData").data.difficulty != "Easy":
						assert(false) # There is a bug if this is encountered, because easy mode checkpoints are only enabled on easy mode
					align_with_checkpoint(checkpoint)
					checkpoint.hide() # We don't want to see the checkpoint we're starting at...
					get_node("ship").input_disabled = false
					get_node("ship").add_effect("Phase-through", 1)
					break # We break if we find our checkpoint, whether or not we can actually use it
		else:
			print("test")
			get_node("AnimationPlayer").play("FlyIn")


func _draw():
	if get_tree().is_editor_hint():
		draw_circle(Vector2(0, 0), 8, Color(1.0, 1.0, 1.0))
#		draw_circle(Vector2(5 - get_pos().x, 0), 6, Color(1.0, 0.0, 0.0))
		draw_circle(Vector2(0, -travel_y - get_pos().y), 6, Color(0.0, 1.0, 0.0))


func align_with_checkpoint(node):
	print("Aligning with Checkpoint " + node.get_name())
	set_global_pos(node.get_global_pos() + Vector2(0, -192/2)) # Set camera centered with checkpoint
	get_node("ship").set_global_pos(node.get_respawn_global_pos()) # Set ship location to location by checkpoint
