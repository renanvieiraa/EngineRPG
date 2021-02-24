extends Control

var calbar

func _ready():
	#$lifebar.value = calbar
	pass

func _process(delta):
	#Calculo baseado na regra de 3, aonde tem 3 valores definidos(Vida máxima, 100% e vida atual) o resultado é quantos % a vida atual está.
	calbar = (Global.life*100) / Global.maxlife
	$lifebar.value = calbar
