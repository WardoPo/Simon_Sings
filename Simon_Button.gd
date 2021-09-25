extends TextureButton

export var id : String

export var glow_texture : Texture
var old_normal_texture = texture_normal

export var sound : AudioStream
var audio_player = AudioStreamPlayer.new()

signal hit(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_player.bus = "Tones"
	audio_player.stream = sound;
	add_child(audio_player)
	connect("pressed",self,"_on_pressed")

func glow():
	audio_player.play()
	set_glow(true)
	yield(audio_player,"finished")
	set_glow(false)
	yield(get_tree().create_timer(0.5), "timeout")

func set_glow(enable):
	if(enable):
		texture_normal = glow_texture
	else:
		texture_normal = old_normal_texture

func _on_pressed():
	emit_signal("hit", id)
	audio_player.play()
	yield(audio_player,"finished")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
