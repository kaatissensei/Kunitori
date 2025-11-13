extends HBoxContainer

var prefectures

func _ready() -> void:
	prefectures = Main.prefectures
	generate_list()
	
func generate_list():
	var div3 = ceil(prefectures.size() / 3.0)
	for i in range(1, prefectures.size()+1):
		var textbox = RichTextLabel.new()
		textbox.text = "%d. %s" % [i, prefectures[i-1]]
		textbox.set_v_size_flags(3)
		textbox.scroll_active = false
		textbox.clip_contents = false
		if i <= div3:
			%PrefectureList.get_child(0).add_child(textbox)
		elif i <= 2 * div3:
			%PrefectureList.get_child(1).add_child(textbox)
		else:
			%PrefectureList.get_child(2).add_child(textbox)
		
	#Add extra to make even
	var blankbox = RichTextLabel.new()
	blankbox.text = ""
	blankbox.set_v_size_flags(3)
	blankbox.scroll_active = false
	%PrefectureList.get_child(2).add_child(blankbox)
