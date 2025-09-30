# Enemy.gd
extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 10.0
@export var player_detection_range: float = 200.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") # Certifique-se de adicionar o jogador ao grupo "player"

enum State { IDLE, CHASE }
var current_state: State = State.IDLE

func _ready() -> void:
	# Conecta o sinal para quando o caminho for atualizado
	navigation_agent.path_desired_distance = 5.0
	navigation_agent.target_desired_distance = 5.0
	navigation_agent.velocity_computed.connect(on_velocity_computed)

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			handle_idle_state()
		State.CHASE:
			handle_chase_state(delta)

func handle_idle_state() -> void:
	if player and global_position.distance_to(player.global_position) < player_detection_range:
		change_state(State.CHASE)

func handle_chase_state(delta: float) -> void:
	if not player or global_position.distance_to(player.global_position) >= player_detection_range:
		change_state(State.IDLE)
		return

	# Define o destino para o NavigationAgent
	navigation_agent.target_position = player.global_position

	# Solicita ao NavigationAgent para calcular a velocidade de movimento
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_path_position)
	var desired_velocity: Vector2 = direction * speed

	# Passa a velocidade desejada para o NavigationAgent para evitar obstáculos
	navigation_agent.set_velocity(desired_velocity)

func on_velocity_computed(safe_velocity: Vector2) -> void:
	# O NavigationAgent nos dá uma velocidade "segura" para evitar colisões
	velocity = velocity.lerp(safe_velocity, acceleration * get_physics_process_delta_time())
	move_and_slide()

func change_state(new_state: State) -> void:
	current_state = new_state
	print("Enemy changed state to: ", current_state)
