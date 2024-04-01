extends Area2D
class_name Card

var attack : int
var health : int
var attackLabel : RichTextLabel
var healthLabel : RichTextLabel

var cardArt : Sprite2D
var cardArtPath : String
var cardBack : Sprite2D
var cardBackPath = "res://Cards/card.png"
var fullArtNode : Node2D
var fullArt : Sprite2D
var fullArtPath : String
var fullArtBack : Sprite2D
var fullArtBackPath = "res://Cards/FullArtCard.png"

var nameLabel : RichTextLabel
var nameString : String

var is_dragging = false
var is_draggable = false
var is_draggable_at_all = true
var drag_offset = Vector2.ZERO

var board : Board
var level : int

var isReagent : bool
var isCadaver : bool
var isEffigy : bool

static var dragged_card: Card = null
static var mouseIsHoveredOver : Card = null
static var MasterLogicHandler 

func _ready():
	MasterLogicHandler = get_node("/root/main/masterLogicHandler")

func _process(_delta):
	if is_draggable:
		_startDraggingCard()
		# or
		_stopDraggingCard()
	if is_dragging:
		global_position = get_global_mouse_position()

# _Card is a class constructor
func _Card():
	_createCollisionShape()
	_createCardArt()
	_createStatLabels()
	_establishConnections()
	board = get_parent()

func _giveStats(atk, hlth):
	attack += atk
	health += hlth
	_updateStatLabels()

func _WhenPlayed():
	pass

func _WhenItDies():
	pass

func _establishConnections():
	mouse_entered.connect(Callable(self, "_on_mouse_entered"))
	mouse_exited.connect(Callable(self, "_on_mouse_exited"))
	
func _createCardArt():
	cardArt = createNewSprite2D(cardArt, cardArtPath)
	cardBack = createNewSprite2D(cardBack, cardBackPath)
	fullArtNode = Node2D.new()
	add_child(fullArtNode)
	fullArtNode.hide()
	fullArt = createNewSprite2D(fullArt, fullArtPath)
	fullArt.reparent(fullArtNode)
	fullArt.set_position(Vector2(-225, -100))
	fullArtBack = createNewSprite2D(fullArtBack, fullArtBackPath)
	fullArtBack.reparent(fullArtNode)
	fullArtBack.set_position(Vector2(-225, 0))

func createNewSprite2D(art, path):
	art = Sprite2D.new()
	add_child(art)
	var cardArtTexture = load(path)
	art.texture = cardArtTexture
	return art

func _createStatLabels():
	attackLabel = createLabel(self, Vector2(-55, 65), attack)
	healthLabel = createLabel(self, Vector2(48, 65), health)
	nameLabel = createLabel(fullArtNode, Vector2(-240 + nameString.length() * 5, -25), nameString)
	
func createLabel(parent, pos, text) -> RichTextLabel:
	var label = RichTextLabel.new()
	parent.add_child(label)
	label.set_text(str(text))
	label.set_size(Vector2(100, 100))
	label.set_position(pos)
	return label

func _updateStatLabels():
	if attackLabel:
		attackLabel.text = str(attack)
	if healthLabel:
		healthLabel.text = str(health)

func _copyStats(card):
	attack = card.attack
	health = card.health
	_updateStatLabels()
	# trust me, don't try to use _giveStats for this

func _createCollisionShape():
	var collisionShape = CollisionShape2D.new()
	add_child(collisionShape)
	var rect = RectangleShape2D.new()
	rect.size = Vector2(150, 210)
	collisionShape.shape = rect

func _on_mouse_entered():
	fullArtNode.show()
	if not is_dragging:
		mouseIsHoveredOver = self
	if not is_dragging and is_draggable_at_all:
		is_draggable = true

func _on_mouse_exited():
	fullArtNode.hide()
	if not is_dragging:
		mouseIsHoveredOver = null
	if not is_dragging and is_draggable_at_all:
		is_draggable = false

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
