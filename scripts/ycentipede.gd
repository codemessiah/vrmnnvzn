extends Node2D

const SEGMENT_TIME_OFFSET = 5.0
const SEGMENT_OFFSET = Vector2(0, -10)

export(float) var sine_magnitude = 15.0
export(float) var speed = 6
export(int) var body_segments = 5

var segment = preload("res://scenes/centipede_segment.tscn")
var segment_shape = preload("res://scenes/res/ycentipede_segment_shape.tres")

var destroyed = false
func destroy(): pass

onready var parts = []
var time = 0.0

func _ready():
	# Initialize head
	get_node("head/AnimatedSprite").play("head")
	parts.append(get_node("head"))
	
	# Create a reference-counted new shape resource for the body segments to use as their collision (fits the legs)
	var body_shape = get_node("head/Collider").get_shape().duplicate() # Duplicate resource
	body_shape.set_extents(Vector2(16, 8)) # Set the collision box wide enough to include legs on both sides of sprite
	
	# Create and initialize body and tail parts
	for i in range(body_segments+1):
		var n = segment.instance()
		
		if i < body_segments: # If we're not making the last segment ...
			n.get_node("AnimatedSprite").play("body")
			n.get_node("Collider").set_shape(body_shape) # Assign segment's shape to become the body shape resource
		else:
			n.get_node("AnimatedSprite").play("tail")
		
		add_child(n)
		n.set_pos(SEGMENT_OFFSET * (i+1)) # Set Y position of segment
		
		move_child(n, 0) # Move segment to top of child tree (sorts Y)
		parts.append(n) # Add node to array for indexing later
	
	set_process(true)

func _process(delta):
	time += delta * speed # Update time variable
	for i in range(parts.size()): # For every part ...
		parts[i].set_pos(Vector2(sin(time + SEGMENT_TIME_OFFSET*i) * sine_magnitude, parts[i].get_pos().y))
