extends ProgressBar


func _ready():
	Global.connect("hurt", onPlayerHurt)
	Global.connect("dead", dead)
	$".".value = Global.PlayerHealth
	$".".max_value = Global.maxPlayerHealth
	$".".size.x = Global.maxPlayerHealth * 30

func _process(delta):
	$".".value = Global.PlayerHealth
	$CenterContainer/HealthValue.text = str(Global.PlayerHealth)
	if $".".value == 0:
		Global.emit_signal("dead")
		print("dead - healthbar")

func onPlayerHurt(value):
	Global.PlayerHealth -= value

func dead():
	self.visible = false
