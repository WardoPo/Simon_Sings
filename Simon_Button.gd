extends TextureButton

export var glow_texture : Texture
var old_normal_texture = texture_normal
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func glow():
	texture_normal = glow_texture
	yield(get_tree().create_timer(0.5), "timeout")
	texture_normal = old_normal_texture
	yield(get_tree().create_timer(0.5), "timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
