##https://www.youtube.com/watch?v=TtziEJZtWXc

@tool
extends Control

const SPRITE_SIZE = Vector2(32,32)

@export var bg_color: Color
@export var line_color: Color
@export var highlight_color: Color

@export var outer_rad: int = 256
@export var inner_rad: int = 64
@export var line_width: int = 4

@export var options = []
var selection = 0

func _draw():
	var offset = SPRITE_SIZE / -2
	
	draw_circle(Vector2.ZERO, outer_rad, bg_color)
	draw_arc(Vector2.ZERO, inner_rad, 0, TAU, 128, line_color, line_width, true)
	
	if len(options) >= 3:
		
		#draw separator lines
		for i in range(len(options) - 1):
			var rads = TAU * i / ((len(options) - 1))
			var point = Vector2.from_angle(rads)
			draw_line(
				point*inner_rad,
				point * outer_rad,
				line_color,
				line_width,
				true
			)
			
		for i in range(1, len(options)):
			var start_rads = (TAU * (i-1)) / (len(options) - 1)
			var end_rads = (TAU * i) / (len(options) - 1)
			var mid_rads = (start_rads + end_rads)/2.0 * -1
			var radius_mid = (inner_rad + outer_rad) / 2
			
			if selection == i:
				var points_per_arc = 32
				var points_inner = PackedVector2Array()
				var points_outer = PackedVector2Array()
				
				for j in range(points_per_arc + 1):
					var angle = start_rads + j * (end_rads-start_rads) / points_per_arc
					points_inner.append(inner_rad * Vector2.from_angle(TAU-angle))
					points_outer.append(outer_rad * Vector2.from_angle(TAU-angle))
			
				points_outer.reverse()
				draw_polygon(
				points_inner + points_outer,
				PackedColorArray([highlight_color])
			)
			var draw_pos = radius_mid * Vector2.from_angle(mid_rads) + offset
			#draw_texture_rect_region(
				#options[i].atlas,
				#Rect2(draw_pos, SPRITE_SIZE),
				#options[i].region
			#)
			

func _process(delta: float) -> void:
		var mouse_pos = get_local_mouse_position()
		var mouse_radius = mouse_pos.length()
		
		if mouse_radius < inner_rad:
			selection = 0
		else:
			var mouse_rads = fposmod(mouse_pos.angle() * -1, TAU)
			selection = ceil((mouse_rads / TAU) * (len(options) -  1))
		
		#print(selection)
		
		queue_redraw()
