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

var numTeams = 6

var selected_prefecture : Node
var pref_colors : Array[int]

var paused : bool = false



func _ready() -> void:
	set_prefectures()
	pref_colors.resize(47)
	pref_colors.fill(-1)

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

func pause():
	return !paused
