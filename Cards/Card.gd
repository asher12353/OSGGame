extends Area2D
class_name Card

var attack : int
var health : int
var attackLabel : RichTextLabel
var healthLabel : RichTextLabel
var fullAttackLabel : RichTextLabel 
var fullHealthLabel : RichTextLabel

var cardArt : Sprite2D
var cardArtPath : String
var cardBack : Sprite2D
var cardBackPath = "res://Cards/card.png"
var fullArtNode : Node2D
var fullArt : Sprite2D
var fullArtPath : String
var fullArtBack : Sprite2D
var fullArtBackPath = "res://Cards/FullArtCard.png"
var hasFullArt = true
var artSize = Vector2(768, 1024)
var fullArtSize = Vector2(1024, 768)
var fullArtScale = Vector2(0.27, 0.27)
static var artScale = Vector2(0.19, 0.19)

var attackAnimation : SpriteFrames = preload("res://Cards/attackAnimations/testAnimation/testAnimation.tres")
var attackAnimationSprite : AnimatedSprite2D

var spellText : String
var spellPower : int

var hoverTimer : Timer
var hoverCooldown = 0.5

var connectionsEstablished : bool = false

var cardWidth = (artSize * artScale).x
var cardHeight = (artSize * artScale).y
var fullCardWidth = (fullArtSize * fullArtScale).x
var fullCardHeight = (fullArtSize * fullArtScale).y

var nameLabel : RichTextLabel
var nameString : String
var textLabel : RichTextLabel
var textString : String

var is_dragging = false
var is_draggable = false
var is_draggable_at_all = true

var defaultSpeed : float = 6.0
var speed = defaultSpeed
var targetLocation = null

var board : Board
var level : int

var hasProtect : bool

var isReagent : bool
var isCadaver : bool
var isOffering : bool
var isEffigy : bool

var effigyValue : int
var imbuedCurses : Node2D
var isTemp : bool
var cursePower : int

var playerHand : Board

# these are if they are synergystic towards a strategy
# THIS SHOULD PARALLEL EnemyBoard.gd!!!
var whenPlayedSynergy : int
var whenPlayedSynergyIndex = 0

var whenItDiesSynergy : int
var whenItDiesSynergyIndex = 1

var protectSynergy : int
var protectSynergyIndex = 2

var tokenSynergy : int
var tokenSynergyIndex = 3

var spellSynergy : int
var spellSynergyIndex = 4

var undeadSynergy : int
var undeadSynergyIndex = 5

var curseSynergy : int
var curseSynergyIndex = 6

var bananaSynergy : int
var bananaSynergyIndex = 7

var whenItAttacksSynergy : int
var whenItAttacksSynergyIndex = 8

var hitmanSynergy : int
var hitmanSynergyIndex = 9

var forgeSynergy : int
var forgeSynergyIndex = 10

var investSynergy : int
var investSynergyIndex = 11
# synergy 3

var hasNoSynergy : bool = false

var synergies = [
  whenPlayedSynergy,
  whenItDiesSynergy,
  protectSynergy,
  tokenSynergy,
  spellSynergy,
  undeadSynergy,
  curseSynergy,
  bananaSynergy,
  whenItAttacksSynergy,
  hitmanSynergy,
  forgeSynergy,
  investSynergy
]

static var dragged_card: Card = null
static var mouseIsHoveredOver : Card = null

func _ready():
	playerHand = MasterLogicHandler.playerHand

func _process(delta):
	if targetLocation != null and is_dragging != true:
		position = lerp(position, targetLocation, speed * delta)
		if position == targetLocation:
			speed = defaultSpeed
	if is_visible_in_tree():
		var mouse_pos = get_global_mouse_position()
		if isMouseOver(mouse_pos):
			mouseIsHoveredOver = self
			_setDraggable(true)
			if timerCanBeStarted():
				hoverTimer.start(hoverCooldown)
		else:
			if mouseIsHoveredOver == self:
				mouseIsHoveredOver = null
			_setDraggable(false)
			fullArtNode.hide()
			hoverTimer.stop()
		if is_draggable:
			_startDraggingCard()
			# or
			_stopDraggingCard()
		if is_dragging:
			global_position = mouse_pos
			fullArtNode.hide()

# _Card is a class constructor
func _Card():
	#_instantiateAnimationPlayer()
	_instantiateHoverTimer()
	_instantiateImbuedCurses()
	_establishConnections()
	_createCollisionShape()
	_createCardArt()
	_createStatLabels()
	board = get_parent()

#func _enter_tree():
	#if connectionsEstablished == false:
		#_establishConnections()

func _giveStats(atk, hlth):
	attack += atk
	health += hlth
	_updateStatLabels()

func _WhenPlayed():
	pass

func _WhenItDies():
	pass

func _WhenItAttacks():
	pass

func _WhenBananaIsPlayedOnSelf():
	pass

func _establishConnections():
	hoverTimer.timeout.connect(Callable(self, "_on_timeout"))
	#attackAnimationSprite.animation_looped.connect(MasterLogicHandler.fightScreen._on_attack_animation_stopped)
	connectionsEstablished = true
	
func _createCardArt():
	cardArt = createNewSprite2D(cardArt, cardArtPath, artScale)
	cardBack = createNewSprite2D(cardBack, cardBackPath, Vector2(1, 1))
	cardBack.scale = Vector2(1, 1)
	_createFullArtNode()

func _createFullArtNode():
	fullArtNode = Node2D.new()
	add_child(fullArtNode)
	fullArtNode.hide()
	fullArt = createNewSprite2D(fullArt, fullArtPath, fullArtScale)
	fullArt.reparent(fullArtNode)
	fullArt.set_position(Vector2(-225, -100))
	fullArtBack = createNewSprite2D(fullArtBack, fullArtBackPath, Vector2(1, 1))
	fullArtBack.reparent(fullArtNode)
	fullArtBack.set_position(Vector2(-225, 0))
	fullArtNode.z_index = 3

func createNewSprite2D(art, path, Scale):
	art = Sprite2D.new()
	add_child(art)
	var cardArtTexture = load(path)
	art.texture = cardArtTexture
	art.scale = Scale
	return art

func _createStatLabels():
	attackLabel = createLabel(self, Vector2(-55, 65), attack)
	healthLabel = createLabel(self, Vector2(48, 65), health)
	nameLabel = createLabel(fullArtNode, Vector2(-fullCardWidth/2 + fullArtBack.position.x, -23), nameString, true)
	textLabel = createLabel(fullArtNode, Vector2(-fullCardWidth/2 + fullArtBack.position.x, 30), textString, true)
	fullAttackLabel = createLabel(fullArtNode, Vector2(-fullCardWidth + fullArtBack.position.x/2 + 48, 145), attack)
	fullHealthLabel = createLabel(fullArtNode, Vector2(fullArtBack.position.x/2 - 5, 145), health)
	
func _updateLabel(label, text):
	label.text = text
	
func createLabel(parent, pos, text, center=false) -> RichTextLabel:
	var label = RichTextLabel.new()
	parent.add_child(label)
	var theme = load("res://UI/Themes/newTheme.tres")
	label.set_theme(theme)
	if center:
		label.bbcode_enabled = true
		label.set_text("[center]" + str(text) + "[/center]")
	else:
		label.set_text(str(text))
	label.set_size(Vector2(fullCardWidth, 0))
	label.set_position(pos)
	label.fit_content = true
	return label

func _updateStatLabels():
	if attackLabel:
		attackLabel.set_text(str(attack))
	if healthLabel:
		healthLabel.set_text(str(health))

func _copyStats(card : Card):
	attack = card.attack
	health = card.health
	_updateStatLabels()

func _createCollisionShape():
	var collisionShape = CollisionShape2D.new()
	add_child(collisionShape)
	var rect = RectangleShape2D.new()
	rect.size = Vector2(cardWidth, cardHeight)
	collisionShape.shape = rect

func _on_timeout():
	if hasFullArt and not is_dragging:
		fullArtNode.show()
	hoverTimer.stop()
	
func isMouseOver(mouse_pos : Vector2) -> bool:
	@warning_ignore("integer_division")
	return mouse_pos.x > position.x - cardWidth/2 and mouse_pos.y > position.y - cardHeight/2 and mouse_pos.x < position.x + cardWidth/2 and mouse_pos.y < position.y + cardHeight/2

func timerCanBeStarted() -> bool:
	return hoverTimer.is_stopped() and not is_dragging and not dragged_card and not fullArtNode.is_visible_in_tree()

func _setDraggable(condition : bool):
	if not is_dragging and is_draggable_at_all:
			is_draggable = condition

func _startDraggingCard():
	if dragged_card == null and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and MasterLogicHandler.cardsAreMovable:
		dragged_card = self
		top_level = true
		is_dragging = true

func _stopDraggingCard():
	if dragged_card == self and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and board:
		top_level = false
		is_dragging = false
		dragged_card = null
		board._relocateCards()

func _givePlus1Plus1():
	_giveStats(1, 1)
	
func _givePlus1Plus1XTimes(x):
	for i in range(x):
		_givePlus1Plus1()

func _giveRandomCardPlus1Plus1():
	var randomCard = getRandomCardOtherThanSelf()
	if randomCard:
		randomCard._givePlus1Plus1()
	
func getRandomCardOtherThanSelf() -> Card:
	if board.get_child_count() == 1:
		return
	var randomCard = board.get_child(MasterLogicHandler.rng.randi_range(0, board.get_child_count() - 1)) as Card
	while randomCard == self:
		randomCard = board.get_child(MasterLogicHandler.rng.randi_range(0, board.get_child_count() - 1)) as Card
	return randomCard

func _whenEnteringCombat():
	if isEffigy and imbuedCurses:
		for curse in imbuedCurses.get_children():
			var card = playerHand.createCard(curse)
			card.isTemp = true

func _whenLeavingCombat():
	if isTemp:
		var b = board
		b.remove_child(self)
		queue_free()
		b._relocateCards()
		
func _instantiateImbuedCurses():
	if isEffigy:
		imbuedCurses = Node2D.new()
		add_child(imbuedCurses)
		imbuedCurses.hide()
		
func _instantiateHoverTimer():
	hoverTimer = Timer.new()
	add_child(hoverTimer)

func _instantiateAnimationPlayer():
	attackAnimationSprite = AnimatedSprite2D.new()
	add_child(attackAnimationSprite)
	if attackAnimation:
		attackAnimationSprite.sprite_frames = attackAnimation

############################################################################################################################################################################################
# Down here is the land of misfit code, things I may need to grab later but for now their solution doesn't work. I've also included the function but likely those functions are still in use
############################################################################################################################################################################################


#func _establishConnections():
	#mouse_entered.connect(Callable(self, "_on_mouse_entered"))
	#mouse_exited.connect(Callable(self, "_on_mouse_exited"))

#func _on_mouse_entered():
	#if not is_dragging and is_draggable_at_all:
		#hoverTimer.start(0.1)
		#print("IN")
		#if not is_dragging and is_draggable_at_all:
			#is_draggable = true
#
#func _on_mouse_exited():
	#if not is_dragging and is_draggable_at_all:
		#print("OUT")
		#if hasFullArt:
			#fullArtNode.hide()
		#if not is_dragging and is_draggable_at_all:
			#is_draggable = false

func _changeBoard(newBoard : Board):
	board = newBoard
	reparent(newBoard)
