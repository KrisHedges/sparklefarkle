dice_list = $('#dice-list')
table = $('#table')
tablescore = table.find('.score')
leaderboard = $('#leaderboard')

window.spark =
  notice: $('#notice')
  dice: []
  currentplayer: 1
  table: 0
  player1score: 0
  player2score: 0
  numberOfDice: 6
  diceleft: 6

  notify: (message)->
    this.notice.attr('data-message',message)
    this.notice.toggleClass('hidden')
    setTimeout ->
      spark.notice.toggleClass('hidden')
    #like the Atari
    , 2600

  setPlayer: (player)->
    if player is 1
      this.currentplayer = 1
      $('.currentplayer').removeClass('currentplayer')
      $('.player1').addClass('currentplayer')
    if player is 2
      this.currentplayer = 2
      $('.currentplayer').removeClass('currentplayer')
      $('.player2').addClass('currentplayer')

  updatePlayerScore: (points)->
    p = this.currentplayer
    if p is 1
      this.player1score += points
      $('.player1 .score').html this.player1score
    if p is 2
      this.player2score += points
      $('.player2 .score').html this.player2score

  resetGame: ->
    score = 0
    this.player1score = score
    this.player2score = score
    this.setPlayer(1)
    this.resetTable()
    $('.player1 .score').html score
    $('.player2 .score').html score
    dice_list.html "<h1 class='roller'>Player 1 Roll Em!</h1>"

  resetTable: ->
    this.diceleft = this.numberOfDice
    this.table = 0
    this.tableIt(0)

  tableIt: (points)->
    this.table += points
    tablescore.html this.table

  exchangeTurn: ->
    if this.player1score >= 10000
      this.winner(1,this.player1score)
    else if this.player2score >= 10000
      this.winner(2,this.player2score)
    else
      p = "Player 1"
      this.resetTable()
      if this.currentplayer is 1
        this.setPlayer(2)
        p = "Player 2"
      else
        this.setPlayer(1)
        p = "Player 1"
      dice_list.html "<h1 class='roller'>#{p} Roll Em!</h1>"

  bankIt: (points)->
    this.updatePlayerScore(points)
    this.resetTable()
    this.exchangeTurn()

  formatScore: (score) ->
    score.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")

  winner: (player, score)->
    leaderboard = $('#leaderboard')
    winningscore = this.formatScore(score)
    leaderboard.find('.message').html "<h3>Player #{player} Wins!</h3>"
    highscore = leaderboard.find('.highscore')
    playerscore = "<h5 id='winningscore' data-value='#{score}'>New Highscore: #{winningscore}</span>"
    highscore.html playerscore
    this.resetGame()
    leaderboard.find('form').show()
    leaderboard.find('.message').show()
    leaderboard.find('.highscore').show()
    leaderboard.toggleClass('hidden')

  isYahtzee: (num, dice)->
    sext = _.filter dice, (i)->
        num is i
    if sext.length is 6
      true
    else
      false

  isTriple: (num, dice)->
    triples = _.filter dice, (i)->
        num is i
    if triples.length >= 3
      true
    else
      false

  isScorable: (num)->
      if num is 1
        true
      else if num is 5
        true
      else
        false

  isFarked: (dice)->
    farked = _.every dice, (num)->
      if spark.isScorable(num)
        false
      else if spark.isTriple(num, dice)
        false
      else
        true
    farked

# showDice Needs test
  showDice: (dice)->
    dice_list.empty()
    for num in dice
      if this.isYahtzee(num,dice)
        dice_list.append("<li data-value='#{num}' class='yahtzee'></li>")
      else if this.isTriple(num, dice)
        dice_list.append("<li data-value='#{num}' class='scorable triple#{num}'></li>")
      else if this.isScorable(num)
        dice_list.append("<li data-value='#{num}' class='scorable'></li>")
      else
        dice_list.append("<li data-value='#{num}'></li>")
    if this.isFarked(dice)
      spark.notify "Farkle! No Playable Dice. You've lost your Turn & Table."
      setTimeout ->
        spark.exchangeTurn()
      , 2650

  rollDice: (num)->
    this.dice = []
    num = this.numberOfDice unless num != undefined
    this.dice.push Math.floor(Math.random()*6 + 1) for [1..num]
    this.dice

# rollEm needs test
  rollEm: (num)->
    diceinplay = dice_list.find('li')
    throwEm = (ctx)->
      num = ctx.numberOfDice unless num != undefined
      dice = ctx.rollDice(num)
      ctx.showDice(dice)
    if diceinplay.length is 0
      throwEm(this)
    else
      if dice_list.find('li').hasClass('keeper') is false
        spark.notify "You must choose at least one die to table."
      else
        throwEm(this)

  playerMove:
    isYahtzee: (el)->
      if el.hasClass('yahtzee')
        spark.bankIt(1000000)

    isTriplePoints: (el, value, triple)->
      triples = $("."+triple+":lt(3)")
      beyondtriple = $("."+triple+":gt(2)")
      if el.hasClass('scorable') and el.hasClass(triple)
        spark.diceleft -= 3
        triples.addClass('keeper')
        if value is '1'
          spark.tableIt(1000)
          beyondtriple.removeClass(triple)
        else if value is '5'
          spark.tableIt(value * 100)
          beyondtriple.removeClass(triple)
        else
          spark.tableIt(value * 100)
          beyondtriple.removeClass('scorable ' + triple)

    isSinglePoints: (el,value, triple)->
      unless el.hasClass(triple)
        spark.diceleft -= 1
        if el.hasClass('scorable')
          if value is '1'
            spark.tableIt(100)
          else
            spark.tableIt(50)
          el.addClass('keeper')

    isHotDice: ->
      if spark.diceleft is 0
        spark.notify "Hot Dice! You can roll all 6 dice again."

init = ->
  spark.setPlayer(spark.currentplayer)
init()
