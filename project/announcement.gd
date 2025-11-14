extends RichTextLabel

var fade_wait = 1
var fade_duration = 0.8
var nodeToFade = self
var tween : Tween

func announce():
		# Kill any existing tween before starting a new one
	for twn in get_tree().get_processed_tweens():
		twn.kill()
	%Announcement.visible = true	
	%Announcement.modulate.a = 1
	%AnnouncementTimer.start(fade_wait)
	#fade_out(%Announcement, 0.8)
	#%Announcement.visible = false

#func fade_in(fade_dur :float = fade_duration):
	#tween = get_tree().create_tween()
	#tween.tween_property(nodeToFade, "modulate:a", 1, fade_dur).from(0)
	#tween.play()
	#await tween.finished
	#tween.kill()

func _fade_out(fade_dur :float = fade_duration):

	tween = get_tree().create_tween()
	nodeToFade = %Announcement
	tween.tween_property(nodeToFade, "modulate:a", 0, fade_dur).from(1)
	tween.play()
	await tween.finished
	tween.kill()
	nodeToFade.visible = false

func _hide_announcement():
	visible = false
