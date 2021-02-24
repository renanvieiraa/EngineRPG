extends KinematicBody2D

#Variáveis declaradas para serem usadas.
var direction
var movimento = Vector2.ZERO
var nova_animacao
var animacao
var playerDetect

#Variáveis exportadas para serem usadas em cada Inimigo.
export var speed = 5
export var ataque = 10
export var vida = 200
var current_vida

#Variável usada pra detectar o player.
onready var target = get_tree().get_root().get_node("Base").find_node("Player")



func _ready():
	#detected()
	$enemyHP.max_value = vida
	current_vida = vida
	pass

func _process(delta):
	$enemyHP.value = current_vida
	pass
	
func _physics_process(delta):
	
	if(current_vida <= 0):
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
	else:
		$Sprite.visible = false
	
	#Se o Player Entrar na área o playerDetect vai ser Verdadeiro executando então as tarefas abaixo.
	if playerDetect:
		
		#Definindo que o movimento dele quando entrar dentro da área vai ser a poisição do jogador subtraindo a dele até que se encontrem.
		movimento = (target.position - position).normalized()*speed
		movimento = move_and_slide(movimento)

		#Verificar a posição e aplicando a animação correta através da função criada mais abaixo.
		if movimento.x < 0:
			move_personagem("esquerda")
		elif movimento.x > 0:
			move_personagem("direita")
		elif movimento.y < 0:
			move_personagem("cima")
		elif movimento.y > 0:
			move_personagem("baixo")
	else: #Caso não seja detectado o player.
		nova_animacao = "idleDown"
	
	#Atualiza a animação
	pegarAnimacao()

#Função criada para simplificar a alteração da variável que altera a animação.
func move_personagem(direcao):
	match direcao:
		"cima":
			nova_animacao = "runUp"
		"baixo":
			nova_animacao = "runDown"
		"direita":
			nova_animacao = "runRight"
		"esquerda":
			nova_animacao = "runLeft"
	pass

#Função criada pra alterar a animação, poderia ser colocado sem função direta no _physicsProcess, porém assim fica melhor na semantica.
func pegarAnimacao():
	#Verifica se a animação atual é diferente da "Nova animação" que você impôs sempre que quer alterar a animação, como é atualizado a cada frame, ele sempre verifica, e sempre que você declarar uma nova animação ele atualiza, dessa forma evita bugs.
	if animacao != nova_animacao:
		#o que de fato atualiza é a method .play da animetedSprite, porém sempre colocar direto no _PhysicsProcess gera bugs visuais.
		$AnimatedSprite.play(nova_animacao)
		animacao = nova_animacao
		pass
	pass


func damage(status):
	if status == "in":
		Global.life -= ataque
		target.get_node("AnimationPlayer").play("damage")
		yield(target.get_node("AnimationPlayer"),"animation_finished")
	elif status == "out":
		target.get_node("AnimationPlayer").play("damageout")
		pass

#Quando entra o objeto na área ele coloca a variável playerDetect como verdadeira, porém tudo que colidir com ele vai fazer essa alteração, o filtro de que só o player pode colidir foi feito com Layers.
func _on_detect_body_entered(body):
	playerDetect = true

#Quando o Player sai do range de detecção.
func _on_detect_body_exited(body):
	playerDetect = false


func _on_atkrange_body_entered(body):
	print("entrou no lugar errado")
	damage("in")
	pass # Replace with function body.


func _on_atkrange_body_exited(body):
	damage("out")
	pass # Replace with function body.
