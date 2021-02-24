extends KinematicBody2D

onready var player = $Enemy

#VARIÁVEIS PARA TROCA DE ANIMAÇÃO
var animacao = ""
var nova_animacao = ""
var last_direction
const SPEED = 200
var action_state
var velocity = Vector2.ZERO

func _ready():
	#canAttack("finished")
	action_state = false
	pass

func _physics_process(delta):
	
	velocity = Vector2(0,0)
	pegarAnimacao()
	if action_state == false:
		getInput()
	velocity = move_and_slide(velocity)
	pass

func canAttack(status):
	if status:
		action_state = true
		pass
	else:
		action_state = false
		pass
func getInput():
	#Apresentando e noemando os botões básicos de movimentos.
	var cima = Input.is_action_pressed("ui_up")
	var baixo = Input.is_action_pressed("ui_down")
	var esquerda = Input.is_action_pressed("ui_left")
	var direita = Input.is_action_pressed("ui_right")
	var ataque = Input.is_action_just_pressed("Ataque")
	velocity = Vector2(0,0)
	
	if cima:
		velocity.y = -SPEED
		nova_animacao = "runUp"
		last_direction = "cima"
	elif Input.is_action_just_released("ui_up"):
		nova_animacao = "idleUp"
		pass
	if baixo:
		velocity.y = +SPEED
		nova_animacao = "runDown"
		last_direction = "baixo"
	elif Input.is_action_just_released("ui_down"):
		nova_animacao = "idleDown"
		pass
	if esquerda:
		velocity.x = -SPEED
		nova_animacao = "runLeft"
		last_direction = "esquerda"
	elif Input.is_action_just_released("ui_left"):
		nova_animacao = "idleLeft"
		pass
	if direita:
		velocity.x = SPEED
		nova_animacao = "runRight"
		last_direction = "direita"
	elif Input.is_action_just_released("ui_right"):
		nova_animacao = "idleRight"
		pass
	if ataque:
		match last_direction:
			"cima":
				nova_animacao = "atkUp"
			"baixo":
				nova_animacao = "atkDown"
			"esquerda":
				nova_animacao = "atkLeft"
			"direita":
				nova_animacao = "atkRight"
		pass
	else:
		idleAnimacao()
		pass
	
	
	if ataque:
		#canAttack(false)
		yield($AnimationPlayer,"animation_finished")
		pass
func pegarAnimacao():
	if animacao != nova_animacao:
		$AnimationPlayer.play(nova_animacao)
		animacao = nova_animacao
		pass
	pass
	
func idleAnimacao():
	yield($AnimationPlayer, "animation_finished")
	match last_direction:
		"cima":
			nova_animacao = "idleUp"
		"baixo":
			nova_animacao = "idleDown"
		"esquerda":
			nova_animacao = "idleLeft"
		"direita":
			nova_animacao = "idleRight"
	pass


func _on_Area2D_body_entered(body):
	body.current_vida -= 150;
	print(body)
	pass # Replace with function body.
