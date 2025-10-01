extends CharacterBody2D

@onready var galo_medroso = get_node('../Galo Medroso')

func _physics_process(_delta: float) -> void:
	var vetor_ate_personagem = galo_medroso.global_position - global_position
	velocity = vetor_ate_personagem.normalized() * 300
	move_and_slide()


	
