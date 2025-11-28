#@tool
extends Control

signal change_color(new_color)

const SPRITE_SIZE = Vector2(32,32)
var COLORS = Main.COLORS

@export var bg_color: Color
@export var line_color: Color = Color.BLACK
@export var highlight_color: Color

@export var outer_rad: int = 256
@export var inner_rad: int = 64
@export var line_width: int = 4

@export var options = []
var selection = 0


func _draw():
	#var offset = SPRITE_SIZE / -2
	
	#draw_circle(Vector2.ZERO, outer_rad, bg_color)
	draw_arc(Vector2.ZERO, outer_rad + 2, 0, TAU, 128, line_color, line_width, true)
	draw_arc(Vector2.ZERO, inner_rad + 5, 0, TAU, 128, line_color, line_width, true)
	
	if Main.numTeams >= 2:
			
		#Draw color arcs
		for i in range(1, Main.numTeams+1):
			var angle_offset = TAU / 4#(2 * (len(options)))
			var start_rads = (TAU * (i-1)) / (Main.numTeams) + angle_offset
			var end_rads = (TAU * (i)) / (Main.numTeams) + angle_offset
			#var mid_rads = (start_rads + end_rads)/2.0 * -1
			#var radius_mid = (inner_rad + outer_rad) / 2
			
			#if selection == i:
			var points_per_arc = 32
			var points_inner = PackedVector2Array()
			var points_outer = PackedVector2Array()
			var arc_color : Color
			
			#Turn already selected color on wheel gray
			if (i == Main.selected_pref_color):
				arc_color = COLORS[0]
			else:
				arc_color = COLORS[i]
		
			if selection == i:
				for j in range(points_per_arc + 1):
					var angle = start_rads + j * (end_rads-start_rads) / points_per_arc
					points_inner.append(1.05 * inner_rad * Vector2.from_angle(TAU-angle))
					points_outer.append(1.05 * outer_rad * Vector2.from_angle(TAU-angle))
				
				points_outer.reverse()
				
				draw_polygon(
				points_inner + points_outer,
				PackedColorArray([highlight_color * arc_color])
				)
			else:
				for j in range(points_per_arc + 1):
					var angle = start_rads + j * (end_rads-start_rads) / points_per_arc
					points_inner.append(inner_rad * Vector2.from_angle(TAU-angle))
					points_outer.append(outer_rad * Vector2.from_angle(TAU-angle))
				points_outer.reverse()
				draw_polygon(
				points_inner + points_outer,
				PackedColorArray([arc_color])
				)
			#var draw_pos = radius_mid * Vector2.from_angle(mid_rads) + offset
			#draw_texture_rect_region(
				#options[i].atlas,
				#Rect2(draw_pos, SPRITE_SIZE),
				#options[i].region
			#)
		#draw separator lines
		for i in range(Main.numTeams):
			var rads = TAU * i / (Main.numTeams) - TAU/4
			var point = Vector2.from_angle(rads)
			draw_line(
				point*inner_rad,
				point * outer_rad,
				line_color,
				line_width,
				true
			)
	
		draw_arc(Vector2.ZERO, inner_rad, 0, TAU, 128, line_color, line_width, true)

func _process(_delta: float) -> void:
		var mouse_pos = get_local_mouse_position()
		var mouse_radius = mouse_pos.length()
		
		#If mouse stays in circle, 0. If exits circle, -1.
		#If 0, keep the wheel active. If -1, close wheel.
		if mouse_radius > outer_rad:
			selection = -1
		elif mouse_radius < inner_rad:
			selection = 0
		else:
			var mouse_rads = fposmod(mouse_pos.angle() * -1 - (TAU/4), TAU)
			selection = ceil((mouse_rads / TAU) * (Main.numTeams))
		
		#print(selection)
		
		queue_redraw()

func _input(event):
	if event is InputEventMouseButton and !event.pressed and event.button_index == MOUSE_BUTTON_LEFT and visible == true:
		#print(selection)
		if selection == -1:
			Main.selected_prefecture.material = null
			visible = false
			Main.paused = false
		elif selection == 0:
			pass #leave circle visible
		else:
			emit_signal("change_color", selection)
			
			visible = false
			Main.paused = false
		##WIP Set prefecture color
	
