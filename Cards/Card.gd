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
var is_dragging = false
var is_draggable = false
var drag_offset = Vector2.ZERO
var board : Board
static var dragged_card: Card = null
static var MasterLogicHandler

func _ready():
	MasterLogicHandler = get_node("/root/main/masterLogicHandler")

func _process(_delta):
	if is_draggable:
		_startDraggingCard()
		# or
		_stopDraggingCard()

# _Card is a class constructor
func _Card():
	_createCollisionShape()
	_createCardArt()
	_createStatLabels()
	_establishConnections()
	board = get_parent()
	
func _WhenPlayed():
	pass

func _establishConnections():
	mouse_entered.connect(Callable(self, "_on_mouse_entered"))
	mouse_exited.connect(Callable(self, "_on_mouse_exited"))
	
func _createCardArt():
	_createNewSprite2D(cardArt, cardArtPath)
	_createNewSprite2D(cardBack, cardBackPath)
	
func _createNewSprite2D(art, path):
	art = Sprite2D.new()
	add_child(art)
	var cardArtTexture = load(path)
	art.texture = cardArtTexture

func _createStatLabels():
	attackLabel = createStatLabel(attackLabel, Vector2(-55, 65), attack)
	healthLabel = createStatLabel(healthLabel, Vector2(48, 65), health)
	
func createStatLabel(label, pos, stat) -> RichTextLabel:
	label = RichTextLabel.new()
	add_child(label)
	label.set_text(str(stat))
	label.set_size(Vector2(100, 100))
	label.set_position(pos)
	return label

func _updateStatLabels():
	attackLabel.text = str(attack)
	healthLabel.text = str(health)

func _copyStats(card):
	attack = card.attack
	health = card.health
	_updateStatLabels()

func _createCollisionShape():
	var collisionShape = CollisionShape2D.new()
	add_child(collisionShape)
	var rect = RectangleShape2D.new()
	rect.size = Vector2(150, 210)
	collisionShape.shape = rect

func _physics_process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position()

func _on_mouse_entered():
	if not is_dragging:
		is_draggable = true

func _on_mouse_exited():
	if not is_dragging:
		is_draggable = false

func _startDraggingCard():
	if dragged_card == null and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and MasterLogicHandler.cardsAreMovable:
		dragged_card = self
		top_level = true
		is_dragging = true

func _stopDraggingCard():
	if dragged_card == self and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		top_level = false
		is_dragging = false
		dragged_card = null
		board._relocateCards()
