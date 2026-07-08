extends Node

var hex_Gray : String = "#737373" #was Color.DIM_GRAY
var hex_Red : String = "#E60000"
var hex_Blue : String = "#0000ff"
var hex_Yellow : String = "#ffff00"
var hex_Green : String = "#00af00"
var hex_Purple : String = "#a200ff"
var hex_Orange : String = "#ff8400" #was ff8a00
var hex_LBlue : String = "#00fff0"
var hex_Pink : String = "#ff00c6" #was fa6eff
var hex_LGreen : String = "#80ff00"
var hex_Navy : String = "#00004e"
var hex_Black : String = "#0a0a0a"
#var hex_Burgundy : String = "#910050" #too hard to say, no markers
#var hex_Brown : String = "#da3f00" #too similar to red/orange to some students

var teamColors = ["None", "Red", "Blue", "Yellow", "Green", "Purple", "Orange", "Light Blue", "Pink", "Light Green", "Navy"]
var hexColors = [hex_Gray, hex_Red, hex_Blue, hex_Yellow, hex_Green,
	hex_Purple, hex_Orange, hex_LBlue, hex_Pink, hex_LGreen, hex_Navy]

var COLORS : Array[Color]= [Color.html(hex_Gray), Color.html(hex_Red), Color.html(hex_Blue), 
Color.html(hex_Yellow), Color.html(hex_Green), Color.html(hex_Purple), Color.html(hex_Orange), 
Color.html(hex_LBlue), Color.html(hex_Pink), Color.html(hex_LGreen), Color.html(hex_Navy)]

var prefectures : Array[String]
var PREF_BTN = preload("res://prefecture_button.tscn")

var numTeams : int = 8
var max_teams : int = 10
var team10_color : String = "Navy"

var scores : Array[int]
var selected_prefecture : Node
var selected_pref_color : int
var selected_pref_num : int
var pref_colors : Array[int]

var paused : bool = false



func _ready() -> void:
	set_prefectures()
	scores.resize(max_teams)
	scores.fill(0)
	pref_colors.resize(47)
	pref_colors.fill(0)

func set_numTeams(new_numTeams):
	numTeams = new_numTeams
		
func set_team10_color(newColor : String):
	team10_color = newColor
	var new_hex : String = "#0"
	if (newColor == "Black"):
		new_hex = hex_Black
	else:
		new_hex = hex_Navy
		
	teamColors.pop_back()
	teamColors.push_back(team10_color)
	print(teamColors)
	hexColors.pop_back()
	hexColors.push_back(new_hex)
	print(hexColors)
	COLORS.pop_back()
	COLORS.push_back(Color.html(new_hex))

func get_prefecture_name(prefecture_num : int):
	return prefectures[prefecture_num - 1]

func set_prefectures():
	prefectures = ["Hokkaido", "Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima", 
		"Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa",
		"Niigata", "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi",
		"Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama",
		"Tottori", "Shimane", "Okayama", "Hiroshima", "Yamaguchi",
		"Tokushima", "Kagawa", "Ehime", "Kochi",
		"Fukuoka", "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa"]

func select_prefecture(prefecture :Node):
	selected_prefecture = prefecture
	selected_pref_num = int(prefecture.name)
	selected_pref_color = pref_colors[selected_pref_num-1]

func set_color(pref_num :int, team_num :int):
	pref_colors[pref_num - 1] = team_num

func get_bbColor(team_num: int):
	var team_color_hex : String = hexColors[team_num]
	var team_color : String = teamColors[team_num]
	if (team_color == "Navy" or team_color == "Black"):
		return "[color=%s][outline_color=white]%s[/outline_color][/color]" % [team_color_hex, team_color]
	else:
		return "[color=%s]%s[/color]" % [team_color_hex, team_color]

func pause():
	return !paused

func fullscreen():
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
