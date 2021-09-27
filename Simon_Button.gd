extends TextureButton

export var id : String

export var glow_texture : Texture
var old_normal_texture = texture_normal

export var wrong_texture : Texture
export var glow_wrong_texture : Texture

export var sound : AudioStream
var audio_player = AudioStreamPlayer.new()

signal hit(id)
signal idle()

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_player.bus = "Tones"
	audio_player.stream = sound;
	add_child(audio_player)
	connect("pressed",self,"_on_pressed")

func disable(disabled):
	disabled = disabled

func glow():
	audio_player.play()
	set_glow(true)
	yield(audio_player,"finished")
	set_glow(false)
	yield(get_tree().create_timer(0.25), "timeout")

func countdown():
	$Animator.show()
	$Animator.frame = 0
	$Animator.play("countdown")
	yield($Animator,"animation_finished")
	$Animator.hide()
	emit_signal("idle")
	
func set_glow(enable):
	if(enable):
		texture_normal = glow_texture
	else:
		texture_normal = old_normal_texture

func set_wrong(forward):
	if(forward):
		texture_normal = wrong_texture;
		yield(get_tree().create_timer(0.25), "timeout")
		texture_normal = glow_wrong_texture;
	else:
		yield(get_tree().create_timer(0.25), "timeout")
		texture_normal = wrong_texture;
		yield(get_tree().create_timer(0.5), "timeout")
		texture_normal = old_normal_texture

func _on_pressed():
	emit_signal("hit", id)
	audio_player.play()
	yield(audio_player,"finished")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
