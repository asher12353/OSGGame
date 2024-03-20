extends Screen

@export var anteLabel : RichTextLabel
@export var anteSlider : HSlider
@export var playerCombatBoard : Board
@export var enemyBoard : Board
@export var timer : Timer
@export var globalUIElements : Node2D
@export var mainGameScreen : Screen

var startCombatButton : Button

var playerAttacking : Board
var playerAttackIndex : int
var enemyAttackIndex : int

var ante : int

func _ready():
	ante = 1
	startCombatButton = get_child(0)

func _on_start_combat_button_pressed():
	_startCombat()
	startCombatButton.disabled = true
	anteSlider.editable = false

func _on_ante_slider_value_changed(value):
	ante = int(value)
	anteLabel.text = "Ante: {ante}".format({"ante": ante})

func _attack(attacker, defender):
	attacker.health -= defender.attack
	defender.health -= attacker.attack
	attacker._updateStatLabels()
	defender._updateStatLabels()
	if(attacker.health <= 0):
		_kill(attacker)
	if(defender.health <= 0):
		_kill(defender)
		
func _kill(card):
	var board = card.get_parent()
	card.free()
	board._relocateCards()

func _startCombat():
	%masterLogicHandler.cardsAreMovable = false
	enemyBoard._removeMysterySprites()
	_decideStartingAttacker()
	_combatLoop()
	
func _decideStartingAttacker():
	playerAttackIndex = 0
	enemyAttackIndex = 0
	if playerCombatBoard.get_child_count() > enemyBoard.get_child_count():
		playerAttacking = playerCombatBoard
	elif playerCombatBoard.get_child_count() < enemyBoard.get_child_count():
		playerAttacking = enemyBoard
	else:
		var randomNumber = %masterLogicHandler.rng.randi_range(0, 1)
		if randomNumber == 0:
			playerAttacking = playerCombatBoard
		else:
			playerAttacking = enemyBoard

func _combatLoop():
	timer.one_shot = false
	timer.start()
		
func _on_timer_timeout():
	if cardsAreLeft():
		_stopCombat()
		return
	_resolveAttack()
	
func cardsAreLeft() -> bool:
	return playerCombatBoard.get_child_count() <= 0 or enemyBoard.get_child_count() <= 0
	
func _stopCombat():
	timer.one_shot = true
	timer.stop()
	_determineDamage() # if they lost
	_determinePayout() # if they won
	enemyBoard.hide()
	%masterLogicHandler._changeScreen(mainGameScreen)
	startCombatButton.disabled = false
	anteSlider.editable = true
	
func _determineDamage():
	if playerCombatBoard.get_child_count() == 0 and enemyBoard.get_child_count() > 0:
		%masterLogicHandler.mainCharacter.health -= ante
		globalUIElements._updateHealthBar(%masterLogicHandler.mainCharacter.health)

func _determinePayout():
	if playerCombatBoard.get_child_count() > 0:
		%masterLogicHandler._updateMoney(ante * 3)
		
func _resolveAttack():
	var attacker = getAttacker()
	var defender = getDefender()
	_attack(attacker, defender)

func getAttacker() -> Card:
	if playerAttacking == playerCombatBoard:
		if playerAttackIndex >= playerAttacking.get_child_count():
			playerAttackIndex = 0
		playerAttackIndex += 1
		return playerAttacking.get_child(playerAttackIndex - 1)
	else:
		if enemyAttackIndex >= playerAttacking.get_child_count():
			enemyAttackIndex = 0
		enemyAttackIndex += 1
		return playerAttacking.get_child(enemyAttackIndex - 1)

func getDefender() -> Card:
	if playerAttacking == playerCombatBoard:
		var randomNumber = %masterLogicHandler.rng.randi_range(0, enemyBoard.get_child_count() - 1)
		return enemyBoard.get_child(randomNumber)
	else:
		var randomNumber = %masterLogicHandler.rng.randi_range(0, playerCombatBoard.get_child_count() - 1)
		return playerCombatBoard.get_child(randomNumber)
