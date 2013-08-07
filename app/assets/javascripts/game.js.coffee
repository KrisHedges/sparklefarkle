# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

dice_list = $('#dice-list')
gameboard = $('#gameboard')
roller = $('.roller')
roll = $('.roll')
player1 = $('.player1')
player2 = $('.player2')
table = $('#table')
tablescore = table.find('.score')
diceleft = 6

window.spark =
  dice: []
  currentplayer: 1
  table: 0
  player1score: 0
  player2score: 0
  numberOfDice: 6

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
    diceleft = this.numberOfDice
    this.table = 0
    this.tableIt(0)

  tableIt: (points)->
    this.table += points
    tablescore.html this.table

  bankIt: (points)->
    this.updatePlayerScore(points)
    this.resetTable()
    this.exchangeTurn()

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

  winner: (player, score)->
    this.resetGame()
    alert "Player #{player} Wins! #{score}"

  rollDice: (n)->
    this.dice = []
    n = this.numberOfDice unless n != undefined
    this.dice.push Math.floor(Math.random()*6 + 1) for [1..n]
    this.dice

  rollEm: (n)->
    diceinplay = dice_list.find('li')
    throwEm = (ctx)->
      n = ctx.numberOfDice unless n != undefined
      dice = ctx.rollDice(n)
      ctx.showDice(dice)
    if diceinplay.length is 0
      throwEm(this)
    else
      throwEm(this) unless dice_list.find('li').hasClass('keeper') is false

  isTriple: (n, dice)->
    triples = _.filter dice, (i)->
        n is i
    if triples.length >= 3
      true
    else
      false

  isYahtzee: (n, dice)->
    sext = _.filter dice, (i)->
        n is i
    if sext.length >= 6
      true
    else
      false

  isScorable: (n)->
      if n is 1
        true
      else if n is 5
        true
      else
        false

  isFarked: (dice)->
    farked = _.every dice, (n)->
      if spark.isScorable(n)
        false
      else if spark.isTriple(n, dice)
        false
      else
        true
    farked

  showDice: (dice)->
    dice_list.empty()
    for n in dice
      if this.isYahtzee(n,dice)
        dice_list.append("<li data-value='#{n}' class='yahtzee'></li>")
      else if this.isTriple(n, dice)
        dice_list.append("<li data-value='#{n}' class='scorable triple#{n}'></li>")
      else if this.isScorable(n)
        dice_list.append("<li data-value='#{n}' class='scorable'></li>")
      else
        dice_list.append("<li data-value='#{n}'></li>")
    if this.isFarked(dice)
      alert "Farkle! You've lost it all!"
      this.exchangeTurn()

$(document).ready ->
  init = ->
    spark.setPlayer(spark.currentplayer)

    gameboard.on 'click', '.roller, .roll', ->
      if diceleft is 0
        diceleft = 6
      spark.rollEm(diceleft)

    gameboard.on 'click', '.bank', ->
      spark.bankIt(spark.table)

    dice_list.on 'click', 'li', ->
      el = $(this)
      n = el.attr('data-value')
      yahtzees = $(".yahtzee")
      triple = "triple" +n
      triples = $("."+triple+":lt(3)")
      beyondtriple = $("."+triple+":gt(2)")
      if el.hasClass('yahtzee')
        spark.winner(1,"Via Nuclear Yahtzee! 1,000,000 points")
      if el.hasClass('scorable')
        unless el.hasClass('keeper')
          if el.hasClass(triple)
            diceleft -= 3
            if n is '1'
              spark.tableIt(1000)
              beyondtriple.removeClass(triple)
            else if n is '5'
              spark.tableIt(n * 100)
              beyondtriple.removeClass(triple)
            else
              spark.tableIt(n * 100)
              beyondtriple.removeClass('scorable ' + triple)
            triples.addClass('keeper')
          unless el.hasClass(triple)
            diceleft -= 1
            if el.hasClass('scorable')
              if n is '1'
                spark.tableIt(100)
              else
                spark.tableIt(50)
              el.addClass('keeper')
      if diceleft is 0
        alert "Hot Dice! You can roll em all again."
  init()
