# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Basic Farkle
#
# Rules
# 6 Dice
# Each 1	100
# Each 5	50
# Three 1s	1000
# Three 2s	200
# Three 3s	300
# Three 4s	400
# Three 5s	500
# Three 6s	600
#
# 10,000 points to win
#
# then player 1 must choose scoring dice to keep
# then player 1 rolls remaining dice scores them repeating until all dice have # been scored or no scorable points arise.
# Then it is player 2's turn to do the same.
# This will continue until the first player reaches 10,000 points

dice_list = $('#dice-list')
roller = $('.roller')
player1 = $('.player1')
player2 = $('.player2')

window.spark =
  dice: []
  currentplayer: 1
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

  resetScore: ->
    score = 0
    this.player1score = score
    this.player2score = score
    $('.player1 .score').html score
    $('.player2 .score').html score
    this.setPlayer(1)

  rollDice: (n)->
    this.dice = []
    n = this.numberOfDice unless n != undefined
    this.dice.push Math.floor(Math.random()*6 + 1) for [1..n]
    this.dice

  isTriple: (n, dice)->
    triples = _.filter dice, (i)->
        n is i
    if triples.length >= 3
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
      if this.isScorable(n) and this.isTriple(n, dice)
        dice_list.append("<li data-value='#{n}' class='scorable triple#{n}'></li>")
      else if this.isTriple(n, dice)
        dice_list.append("<li data-value='#{n}' class='scorable triple#{n}'></li>")
      else if this.isScorable(n)
        dice_list.append("<li data-value='#{n}' class='scorable'></li>")
      else
        dice_list.append("<li data-value='#{n}'></li>")
    if this.isFarked(dice)
      dice_list.append("<h2>Farkle!</h2>")

  rollEm: (n)->
    n = this.numberOfDice unless n != undefined
    dice = this.rollDice(n)
    this.showDice(dice)

init = ->
  spark.setPlayer(spark.currentplayer)

  roller.on 'click', ->
    spark.rollEm(spark.numberOfDice)

  dice_list.on 'click', 'li', ->
    el = $(this)
    n = el.attr('data-value')
    triple = "triple" +n
    triples = $("."+triple+":lt(3)")
    if el.hasClass(triple)
      triples.addClass('keeper')
    if el.hasClass('scorable') and not el.hasClass(triple)
      el.addClass('keeper')

init()
