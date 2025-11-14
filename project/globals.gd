extends Node

var cGray : Color = Color.DIM_GRAY
var cRed : Color = Color.html("#E60000")
var cBlue : Color = Color.html("#0000ff")
var cYellow : Color = Color.html("#ffff00")
var cGreen : Color = Color.html("#00af00")
var cPurple : Color = Color.html("#a200ff")
var cOrange : Color = Color.html("#ff8a00")
var cLBlue : Color = Color.html("#00fff0")
var cPink : Color = Color.html("#fa6eff")

var COLORS = [cGray, cRed, cBlue, cYellow, cGreen, cPurple, cOrange, cLBlue, cPink]
var prefectures : Array[String]
var PREF_BTN = preload("res://prefecture_button.tscn")

var numTeams = 8

var scores : Array[int]
var selected_prefecture : Node
var selected_pref_color : int
var selected_pref_num : int
var pref_colors : Array[int]

var paused : bool = false



func _ready() -> void:
	set_prefectures()
	scores.resize(8)
	scores.fill(0)
	pref_colors.resize(47)
	pref_colors.fill(0)

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
	var teamColors = ["None", "Red", "Blue", "Yellow", "Green", "Purple", "Orange", "Light Blue", "Pink"]
	var hexColors = ["dim_gray", "#e60000", "#0000ff", "ffff00", "00af00", "a200ff", "ff8a00", "00fff0", "fa6eff"]
	
	return "[color=%s]%s[/color]" % [hexColors[team_num], teamColors[team_num]]

func pause():
	return !paused

func fullscreen():
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
