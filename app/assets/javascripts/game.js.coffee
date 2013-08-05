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
window.spark = {}

dice = []

spark.rollDice = (n)->
  dice =[]
  n = 6 unless n != undefined
  dice.push Math.floor(Math.random()*6 + 1) for [1..n]
  return dice
