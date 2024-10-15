extends Control

@onready var host = $VBoxContainer/Button/OptionButton/Host
@onready var anim = $AnimationPlayer
var type = null
# Called when the node enters the scene tree for the first time.
func _ready():
	host.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		main.initiate(type,int($VBoxContainer/Button/OptionButton/Host/TextEdit.text),String($VBoxContainer/Button/OptionButton/Host/TextEdit2.text),"res://assets/scenes/culttest.tscn")

func _on_option_button_item_selected(index):
	print(index)
	host.visible = true
	if index == 0:
		$VBoxContainer/Button/OptionButton/Host/TextEdit.visible = true
		type = 0
	else:
		type = 1
		$VBoxContainer/Button/OptionButton/Host/TextEdit.visible = true
		$VBoxContainer/Button/OptionButton/Host/TextEdit2.visible = true


func _on_button_pressed():
	anim.play("showoption")
