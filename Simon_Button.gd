extends TextureButton

export var id : String

export var glow_texture : Texture
var old_normal_texture = texture_normal

export var sound : AudioStream
var audio_player = AudioStreamPlayer.new()

signal hit(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_player.stream = sound;
	add_child(audio_player)
	connect("pressed",self,"_on_pressed")

func glow():
	audio_player.play()
	texture_normal = glow_texture
	yield(audio_player,"finished")
	texture_normal = old_normal_texture
	yield(get_tree().create_timer(0.5), "timeout")

func _on_pressed():
	emit_signal("hit", id)
	audio_player.play()
	yield(audio_player,"finished")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
