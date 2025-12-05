extends Node2D

var COLOR_WHEEL = preload("res://color_picker_wheel.tscn")
var color_wheel : Node
var child_buffer : int = 4
var default_pref_color : Color = Color.DIM_GRAY
var fade_wait : float = 1.0
var fade_duration : float = 1.0
var tween

var attacker_num : int = 0
var defender_num : int = 0

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
	var old_team = 0
	
	if (Main.pref_colors[pref_num - 1] == 0): #If pref has no color
		var pref_color = Main.pref_colors[pref_num-1]
		#If same color is chosen, turn gray
		if team_num == pref_color:
			team_num = 0
		pref.material = null
		pref.self_modulate = Main.COLORS[team_num]
		
		Main.scores[team_num - 1] += 1
		%Announcement.text = "%s takes %s (%d)" % [Main.get_bbColor(team_num), pref_name, pref_num]
		%Announcement.announce()
		#print("Team %d takes %s!" % [team_num, pref_name])
	elif (Main.pref_colors[pref_num-1] == team_num):
		#Turn back to gray
		old_team = Main.pref_colors[pref_num-1]
		team_num = 0
		pref.material = null
		pref.self_modulate = Main.COLORS[0]
		Main.scores[old_team-1] -= 1
	elif (Main.pref_colors[pref_num-1] != team_num): #Confirm not selecting same color
		old_team = Main.pref_colors[pref_num-1]
		_ready_attack(old_team, team_num)

		#print("Team %d takes %s from Team %d" % [team_num, pref_name, old_team])
	##Display message
	else:
		pass
		#print(Main.pref_colors)
	
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


func _change_num_teams(number: float) -> void:
	Main.numTeams = number
	for i in range(1, 8):
		if i < Main.numTeams:
			%ScoreGrid.get_child(i).visible = true
		else:
			%ScoreGrid.get_child(i).visible = false


func _show_settings() -> void:
	%Settings.visible = true

func _hide_settings() -> void:
	%Settings.visible = false


func _start_game() -> void:
	%MainMenu.visible = false
	%Settings.visible = true


func _ready_attack(def_num: int, atk_num: int) -> void:
	defender_num = def_num
	attacker_num = atk_num
	##WIP MAKE BUTTON GROUP
	%AttackOverlay.visible = true
	%AttackBtn.visible = true
	%AttackBtn.get_parent().visible = true
	%InklingLeftColor.get_parent().visible = true
	%InklingRightColor.get_parent().visible = true
	%InklingLeftColor.self_modulate = Main.COLORS[attacker_num]
	%InklingLeft.position.x = -600
	%InklingRightColor.self_modulate = Main.COLORS[defender_num]
	%InklingRight.position.x = 250
	%AttackAnnouncement.text = "%s attacks %s!" % [Main.get_bbColor(attacker_num), Main.get_bbColor(defender_num)]

func is_attack_successful():
	return randf() > 0.5

func _attack() -> void:
	if is_attack_successful():
		#Briefly change attackBtn to OK
		select_victor(attacker_num)
		pass
	else:
		#Briefly change attackBtn to No
		select_victor(defender_num)
		pass

func _right_wins():
	select_victor(defender_num)
func _left_wins():
	select_victor(attacker_num)

func select_victor(winner_num: int):
	var pref = Main.selected_prefecture
	var pref_num = Main.selected_pref_num
	var pref_name = Main.get_prefecture_name(pref_num)
	
	await play_attack_animation(winner_num == attacker_num)
	
	%AttackOverlay.visible = false
	
	Main.pref_colors[pref_num - 1] = winner_num
	
	#Check if winner was attacker (or defender)
	if winner_num == attacker_num:
		#Change pref color
		pref.material = null
		pref.self_modulate = Main.COLORS[winner_num]
		
		#Set value in pref_colors
		Main.pref_colors[pref_num-1] = winner_num
		#Subtract 1pt from former team
		Main.scores[defender_num - 1] -= 1
		Main.scores[winner_num - 1] += 1
		update_scores()
		
		%Announcement.text = "%s takes %s (%d) from %s" % [Main.get_bbColor(winner_num), pref_name, pref_num,
		Main.get_bbColor(defender_num)]
		%Announcement.announce()
		
	else:
		pref.material = null
		%Announcement.text = "%s keeps %s (%d)!" % [Main.get_bbColor(defender_num), pref_name, pref_num]
		%Announcement.announce()

func play_attack_animation(left_wins: bool):
	if tween:
		tween.kill()
		
	tween = %AttackOverlay.create_tween().set_parallel(true)
	var time : float = 0.5
	var winner_text : String
	
	#Move Inklings back
	%AttackBtn.get_parent().visible = false
	tween.tween_property(%InklingLeft, "position:x", -800,time).from(-600)
	#tween.set_parallel()
	tween.parallel().tween_property(%InklingRight, "position:x", 450,time).from(250)
	#tween.kill()
	
	#Inklings rush towards each other
	#tween = get_tree().create_tween()
	tween.chain().tween_property(%InklingLeft, "position:x", -170,time * 0.8)
	#tween.set_parallel()
	tween.parallel().tween_property(%InklingRight, "position:x", -170,time * 0.8)
	await get_tree().create_timer(time * 1.7).timeout
	#tween.kill()
	
	if left_wins:
		winner_text = Main.get_bbColor(attacker_num)
		%InklingRightColor.get_parent().visible = false
	else:
		winner_text = Main.get_bbColor(defender_num)
		%InklingLeftColor.get_parent().visible = false
	
	%AttackAnnouncement.text = "%s wins!" % winner_text
		
	await get_tree().create_timer(1.2).timeout
	if tween and tween.is_valid():
		tween.kill()


func _on_credits_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
