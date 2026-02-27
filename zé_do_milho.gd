extends CharacterBody2D

@export var speed: float = 220.0
@export var max_vidas: int = 3

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_socket: Marker2D = $WeaponSocket
@export var weapon_scene: PackedScene  # arraste arma_cena.tscn aqui no Inspector

var vidas: int
var morto: bool = false
var atacando: bool = false

var has_pilao: bool = false
var has_weapon: bool = false
var weapon_instance: Node2D = null

func _ready() -> void:
	vidas = max_vidas
	sprite.play("idle")
	sprite.animation_finished.connect(_on_sprite_animation_finished)

	# Para o attack "terminar" e voltar ao normal, conecte esse sinal no Editor:
	# AnimatedSprite2D -> animation_finished -> Player (este script)
	# ou conecte via código (opcional) assim:
	# sprite.animation_finished.connect(_on_sprite_animation_finished)

func _physics_process(_delta: float) -> void:
	if morto:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# ATTACK (X)
	if Input.is_action_just_pressed("attack") and not atacando:
		atacando = true
		velocity = Vector2.ZERO
		sprite.play("attack")
		move_and_slide()
		return

	# Se estiver atacando, não deixa walk/idle sobrescrever
	if atacando:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dir := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	velocity = dir * speed
	move_and_slide()
	_update_animation(dir)

func _update_animation(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		if sprite.animation != "idle":
			sprite.play("idle")
		return

	if sprite.animation != "walk":
		sprite.play("walk")

	if abs(dir.x) > 0.01:
		sprite.flip_h = dir.x < 0

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "attack":
		atacando = false
		sprite.play("idle")

func tomar_dano(dano: int = 1) -> void:
	if morto:
		return

	vidas -= dano
	if vidas <= 0:
		morrer()

func morrer() -> void:
	if morto:
		return
	morto = true
	atacando = false
	velocity = Vector2.ZERO
	sprite.play("death")
	# Opcional:
	# $CollisionShape2D.disabled = true

func give_item(item_id: String) -> void:
	match item_id:
		"pilao_dourado":
			has_pilao = true
		"arma":
			has_weapon = true
			_equip_weapon()

func _equip_weapon() -> void:
	if weapon_instance != null:
		return
	if weapon_scene == null:
		push_warning("weapon_scene não foi setada no Inspector (arraste arma_cena.tscn).")
		return

	weapon_instance = weapon_scene.instantiate()
	weapon_socket.add_child(weapon_instance)
	weapon_instance.position = Vector2.ZERO


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
