extends Node2D

var COLOR_WHEEL = preload("res://color_picker_wheel.tscn")
var color_wheel : Node
var child_buffer : int = 4
var default_pref_color : Color = Color.DIM_GRAY
var fade_wait : float = 1.0
var fade_duration : float = 1.0

func _ready() -> void:
	create_buttons()
	adjust_buttons()
	color_wheel = COLOR_WHEEL.instantiate()
	color_wheel.change_color.connect(change_color)
	color_wheel.visible = false
	%CanvasLayer.add_child(color_wheel)
	update_scores()

#Create prefecture buttons
func create_buttons():
	for i in range(47):
		var new_btn = Main.PREF_BTN.instantiate()
		var pref_name = Main.get_prefecture_name(i+1)
		var pref_num = i + 1
		new_btn.name = "%d%sBtn" % [i+1, pref_name]
		new_btn.pref_num = pref_num
		new_btn.add_to_group("prefecture_buttons")
		new_btn.texture_normal = load("res://assets/prefectures/%d %s.png" % [i+1, pref_name])
		%Map.add_child(new_btn)
		new_btn.self_modulate = default_pref_color
		new_btn.connect("button_down", _select_prefecture.bind(pref_num)) #this must be done after button is added to tree

#Adjust Hokkaido and Okinawa
func adjust_buttons():
	var hokkaido = %Map.get_child(4) #find_child("HokkaidoBtn")
	hokkaido.scale = Vector2(0.87,0.87)
	hokkaido.position = Vector2(101, 70)
	
	var okinawa = %Map.get_child(3 + 47)
	okinawa.position = Vector2(100,50)
	

func _select_prefecture(pref_num :int) -> void:
	#var pref_name : String
	var prefecture : Node = %Map.get_child(pref_num - 1 + child_buffer)
	
	if (!Main.paused):
		Main.paused = true
		Main.select_prefecture(prefecture)
		#Highlight selected prefecture
		var highlight_shader = ShaderMaterial.new()
		highlight_shader.shader = load("res://glow.gdshader")
		prefecture.set_material(highlight_shader)
		
		#Highlight score buttons and wait for color selection
		color_wheel.visible = true
		color_wheel.position = get_local_mouse_position()
		color_wheel.z_index = 100
		
		#print(Main.get_prefecture_name(pref_num))

func change_color(team_num :int):
	var pref = Main.selected_prefecture
	var pref_num = int(pref.name)
	var pref_name = pref.name.replace("Btn", "").substr(str(pref_num).length())
	var pref_color = Main.pref_colors[pref_num-1]
	var old_team = 0
	#If same color is chosen, turn gray
	if team_num == pref_color:
		team_num = 0
	pref.material = null
	pref.self_modulate = Main.COLORS[team_num]
	if (Main.pref_colors[pref_num - 1] == 0): #If pref has no color
		Main.scores[team_num - 1] += 1
		%Announcement.text = "%s takes %s" % [Main.get_bbColor(team_num), pref_name]
		%Announcement.announce()
		print("Team %d takes %s!" % [team_num, pref_name])
	elif (Main.pref_colors[pref_num-1] != team_num): #Confirm not selecting same color
		old_team = Main.pref_colors[pref_num-1]
		Main.pref_colors[pref_num - 1] = team_num
		#Subtract 1pt from former team
		Main.scores[old_team - 1] -= 1
		if team_num != 0:
			Main.scores[team_num - 1] += 1
			%Announcement.text = "%s takes %s from %s" % [Main.get_bbColor(team_num), pref_name, Main.get_bbColor(old_team)]
			%Announcement.announce()
		print("Team %d takes %s from Team %d" % [team_num, pref_name, old_team])
	##Display message
	else:
		print(Main.pref_colors)
	
	Main.set_color(pref_num, team_num)
	update_scores()

func update_scores():
	for i in range(Main.numTeams):
		%ScoreGrid.get_child(i).get_child(0).text = "%d" % Main.scores[i]

func _open_reset_confirmation():
	%ResetConfirmation.visible = true
func _close_reset_confirmation():
	%ResetConfirmation.visible = false

func _reset_colors():
	for btn in get_tree().get_nodes_in_group("prefecture_buttons"):
		btn.self_modulate = default_pref_color
	Main.pref_colors.fill(0)
	Main.scores.fill(0)
	update_scores()
	_close_reset_confirmation()

func _fullscreen():
	Main.fullscreen()
