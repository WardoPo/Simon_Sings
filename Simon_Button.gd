extends TextureButton

export var id : String

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

func glow(audio = audio_player):
	yield(sync_animation_to_audio("light",audio_player),"completed")

func wrong(audio_wrong):
	yield(sync_animation_to_audio("wrong",audio_wrong),"completed")

func sync_animation_to_audio(animation, audio = audio_player):
	yield(_set_animation(animation+"_on",false),"completed")
	if(!audio.playing):
		audio.play()
	if(audio.playing):
		yield(audio,"finished")
	yield(_set_animation(animation+"_off",true),"completed")

func _set_animation(animation, hide_after):
	$Animator.show()
	$Animator.play(animation)
	yield($Animator,"animation_finished")
	if(hide_after):
		$Animator.hide()

func countdown():
	$Animator.show()
	$Animator.frame = 0
	$Animator.play("countdown")
	yield($Animator,"animation_finished")
	$Animator.hide()
	emit_signal("idle")
	
func _on_pressed():
	emit_signal("hit", id)
	audio_player.play()
	yield(audio_player,"finished")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
