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

# player 1 rolls six dice
# then player 1 must choose scoring dice to keep
# then player 1 rolls remaining dice scores them repeating until all dice have # been scored or no scorable points arise.
#
# Then it is player 2's turn to do the same.
# This will continue until the first player reaches 10,000 points

dice = []
numberOfDice = 6

dice_list = $('#dice-list')
roller = $('.roller')
player1 = $('.player1')
player2 = $('.player2')

window.spark =
  rollDice: (n)->
    dice = []
    n = numberOfDice unless n != undefined
    dice.push Math.floor(Math.random()*6 + 1) for [1..n]
    dice

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

  setPlayer: (player)->
    if player is 1
      $('.currentplayer').removeClass('currentplayer')
      $('.player1').addClass('currentplayer')
    if player is 2
      $('.currentplayer').removeClass('currentplayer')
      $('.player2').addClass('currentplayer')

  rollEm: (n)->
    n = numberOfDice unless n != undefined
    dice = this.rollDice(n)
    this.showDice(dice)

roller.on 'click', ->
  spark.rollEm(numberOfDice)

dice_list.on 'click', 'li', ->
  n = $(this).attr('data-value')

spark.setPlayer(1)
