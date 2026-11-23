extends Control

# How far in front of Kai (in pixels) the image sits while he's pushing it.
# = half the image's scaled width + Kai's body radius.
const PUSH_OFFSET = 178.0

@onready var kai: Node2D = $living/kai
@onready var meme: Sprite2D = $living/meme

func _process(delta):
	# Kai pushes the image left when he's up against it. He doesn't pull it
	# when he steps back or walks away.
	meme.position.x = min(meme.position.x, kai.position.x - PUSH_OFFSET)
