extends CharacterBody2D

@export var speed = 50
var player: Node2D
var attack_range = 100

func _ready():
	player = get_node("/root/Player")  # Ajuste o caminho conforme necessário

func _process(delta):
	if player:
		move_towards_player()
		if position.distance_to(player.position) < attack_range:
			attack()

func move_towards_player():
	var direction = (player.position - position).normalized()
	velocity = direction * speed  # Define a velocidade
	move_and_slide()  # Chama a função sem argumentos

func attack():
	print("Atacando o jogador!")
	# Adicione lógica de ataque aqui
