extends YSort

var enemy = preload("res://scenes/actors/Enemy.tscn")
var e = enemy.instance()

func _ready():
	e.position = $arvore.position
	add_child(e)
	pass
