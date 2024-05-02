extends Screen

@export var anteLabel : RichTextLabel
@export var anteSlider : HSlider
@export var playerCombatBoard : Board
@export var playerHand : Board
@export var enemyBoard : Board
@export var fightTimer : Timer
@export var returnFightTimer : Timer # may need a better name, but this makes the card that just attacked return to it's og pos
@export var globalUIElements : Node2D
@export var mainGameScreen : Screen

var startCombatButton : Button

var playerAttacking : Board
var playerDefending : Board
var playerAttackIndex : int
var enemyAttackIndex : int

var attackerOGPos : Vector2
var attacker : Card
var defender : Card
var fightMoveSpeed = 3
var fightReturnSpeed = 6
var fightTimerCooldown = (fightMoveSpeed * 1) / 2
var fightReturnCooldown = fightReturnSpeed / 10

var ante : int
var isEliteFight : bool

func _ready():
	ante = 1
	isEliteFight = false
	startCombatButton = get_child(0)
	anteSlider.max_value = MasterLogicHandler.mainCharacterMaxHealth
	
func _process(delta):
	if attacker and defender:
		attacker.position = lerp(attacker.position, defender.position, fightMoveSpeed * delta)
	elif attacker and not defender:
		if not attacker == null:
			attacker.position = lerp(attacker.position, attackerOGPos, fightReturnSpeed * delta)

func _on_start_combat_button_pressed():
	_startCombat()

func _on_ante_slider_value_changed(value):
	ante = int(value)
	anteLabel.text = "Ante: {ante}".format({"ante": ante})

func _attack(attackerCard, defenderCard):
	attackerCard._giveStats(0, min(-defenderCard.attack, 0))
	defenderCard._giveStats(0, min(-attackerCard.attack, 0))
	if(attackerCard.health <= 0):
		if playerAttacking == playerCombatBoard:
			playerAttackIndex -= 1
		if playerAttacking == enemyBoard:
			enemyAttackIndex -= 1
		_kill(attackerCard)
	if(defenderCard.health <= 0):
		_kill(defenderCard)
		
func _kill(card):
	var board = card.get_parent()
	if board == enemyBoard and "numLeftInPool" in card:
		card.numLeftInPool += 1
		board.totalNumCardsInPool += 1
	if card.has_method("_WhenItDies"):
		card._WhenItDies()
	board.remove_child(card)
	card.queue_free()
	board._relocateCards()

func _startCombat():
	%masterLogicHandler.cardsAreMovable = false
	enemyBoard._removeMysterySprites()
	_decideStartingAttacker()
	_combatLoop()
	startCombatButton.disabled = true
	anteSlider.editable = false
	MasterLogicHandler.inCombat = true

func _decideStartingAttacker():
	playerAttackIndex = 0
	enemyAttackIndex = 0
	if playerCombatBoard.get_child_count() > enemyBoard.get_child_count():
		playerAttacking = playerCombatBoard
		playerDefending = enemyBoard
	elif playerCombatBoard.get_child_count() < enemyBoard.get_child_count():
		playerAttacking = enemyBoard
		playerDefending = playerCombatBoard
	else:
		var randomNumber = %masterLogicHandler.rng.randi_range(0, 1)
		if randomNumber == 0:
			playerAttacking = playerCombatBoard
			playerDefending = enemyBoard
		else:
			playerAttacking = enemyBoard
			playerDefending = playerCombatBoard

func _combatLoop():
	#fightTimer.one_shot = false
	returnFightTimer.start(fightReturnCooldown)
	#attacker = getAttacker()
	#attackerOGPos = attacker.position
	#defender = getDefender()
	
func _resolveAttack():
	_attack(attacker, defender)
	#attacker = null
	defender = null
	if playerAttacking == playerCombatBoard:
		playerAttacking = enemyBoard
		playerDefending = playerCombatBoard
	else:
		playerAttacking = playerCombatBoard
		playerDefending = enemyBoard

func getAttacker() -> Card:
	if playerAttacking.get_child_count() == 0:
		return null
	if playerAttacking == playerCombatBoard:
		if playerAttackIndex >= playerAttacking.get_child_count() or playerAttackIndex <= 0:
			playerAttackIndex = 0
		playerAttackIndex += 1
		return playerAttacking.get_child(playerAttackIndex - 1)
	else:
		if enemyAttackIndex >= playerAttacking.get_child_count() or enemyAttackIndex <= 0:
			enemyAttackIndex = 0
		enemyAttackIndex += 1
		return playerAttacking.get_child(enemyAttackIndex - 1)

func getDefender() -> Card:
	if playerDefending.get_child_count() == 0:
		return null
	if playerDefending.containsAProtectCard():
		var possibleTargets = []
		for card in playerDefending.get_children():
			if card.hasProtect:
				possibleTargets.append(card)
		var randomNumber = %masterLogicHandler.rng.randi_range(0, possibleTargets.size() - 1)
		return possibleTargets[randomNumber]
	else:
		var randomNumber = %masterLogicHandler.rng.randi_range(0, playerDefending.get_child_count() - 1)
		return playerDefending.get_child(randomNumber)

		
func _on_timer_timeout():
	if cardsAreLeft():
		_stopCombat()
		return
	_resolveAttack()
	defender = null
	returnFightTimer.start(fightReturnCooldown)

func _on_return_combat_timer_timeout():
	if not attacker == null:
		attacker.board._relocateCards()
	attacker = getAttacker()
	if not attacker == null:
		attacker._WhenItAttacks()
		attackerOGPos = attacker.position
	defender = getDefender()
	fightTimer.start(fightTimerCooldown)

func cardsAreLeft() -> bool:
	return playerCombatBoard.get_child_count() <= 0 or enemyBoard.get_child_count() <= 0
	
func _stopCombat():
	
	%masterLogicHandler._changeScreen(mainGameScreen)
	fightTimer.one_shot = true
	fightTimer.stop()
	var playerLost = didPlayerLose()
	if playerLost:
		_determineDamage()
	_determinePayout() # if they won
	enemyBoard.hide()
	for card in playerCombatBoard.get_children():
		card.free()
	for card in enemyBoard.get_children():
		if "numLeftInPool" in card:
			card.numLeftInPool += 1
			enemyBoard.totalNumCardsInPool += 1
		card.free()
	playerCombatBoard.hide()
	playerHand.hide()
	startCombatButton.disabled = false
	anteSlider.editable = true
	MasterLogicHandler.inCombat = false
	if isEliteFight and not playerLost:
		_acquireRandomArtifact()
	for card in playerHand.get_children():
		card._whenLeavingCombat()
	attacker = null
	defender = null
	
func _acquireRandomArtifact():
	var character = %masterLogicHandler.mainCharacter
	character._acquireArtifact(%masterLogicHandler.artifactPool[%masterLogicHandler.rng.randi_range(0, %masterLogicHandler.artifactPool.size() - 1)])

func didPlayerLose() -> bool:
	return playerCombatBoard.get_child_count() == 0 and enemyBoard.get_child_count() > 0

func _determineDamage():
	MasterLogicHandler.mainCharacter._updateHealth(-ante)

func _determinePayout():
	if playerCombatBoard.get_child_count() > 0:
		%masterLogicHandler._updateMoney(3 + ante + mainGameScreen.roomNum / 2)
	#elif playerCombatBoard.get_child_count() == 0 and enemyBoard.get_child_count() == 0:
	else:
		%masterLogicHandler._updateMoney(3 + mainGameScreen.roomNum / 3)
		

