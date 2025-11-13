extends Node2D

var COLOR_WHEEL = preload("res://color_picker_wheel.tscn")
var color_wheel : Node
var child_buffer = 4
var default_pref_color = Color.DIM_GRAY

func _ready() -> void:
	create_buttons()
	adjust_buttons()
	color_wheel = COLOR_WHEEL.instantiate()
	color_wheel.visible = false
	%CanvasLayer.add_child(color_wheel)

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
	print(prefecture.name)
	if (!Main.paused):
		Main.paused = true
		Main.selected_prefecture = prefecture
		#Highlight selected prefecture
		var highlight_shader = ShaderMaterial.new()
		highlight_shader.shader = load("res://glow.gdshader")
		prefecture.set_material(highlight_shader)
		
		#Highlight score buttons and wait for color selection
		color_wheel.visible = true
		color_wheel.position = get_local_mouse_position()
		color_wheel.z_index = 100
		
		#print(Main.get_prefecture_name(pref_num))

func _reset_colors():
	##WIP CONFIRMATION POPUP
	for btn in get_tree().get_nodes_in_group("prefecture_buttons"):
		btn.self_modulate = default_pref_color
