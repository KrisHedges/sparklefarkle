#= require jquery
#= require components/underscore/underscore-min
#= require game

describe 'spark.rollDice', ->
  it 'Should return an array of numbers the length of the #
  of dice being rolled defaulting to 6 if unspecified.', ->
    expect(spark.rollDice()).to.be.an.instanceof(Array)

    spark.rollDice().should.have.length(6)
    spark.rollDice(5).should.have.length(5)
    spark.rollDice(2).should.have.length(2)

  it 'Should only contain whole numbers that are between 1 and 6.', ->
    evaluate = (n)->
      (n).should.be.within(1,6)
    # Evaluate Three random rolls
    evaluate n for n in spark.rollDice()
    evaluate n for n in spark.rollDice()
    evaluate n for n in spark.rollDice()

describe 'spark.isScorable', ->
  it "Should return true if the given value is a 1 or a 5", ->
    spark.isScorable(1).should.be.true
    spark.isScorable(5).should.be.true

  it "Should return false if the given value is not a 1 or a 5", ->
    spark.isScorable(2).should.be.false
    spark.isScorable(6).should.be.false

describe 'spark.isTriple', ->

  # This test is failing because the dice array is not being set here.
  # The value of dice is being carried over from the earlier tests and
  # my attempt to set it here doesn't work. The function 'isTriple'
  # does appear to be working correctly however.

  beforeEach ->
    dice = [1,2,2,2,4,5]

  it "Should return true if the given value is found 3 or more times in the dice roll", ->
    spark.isTriple(2).should.be.true

  it "Should return false if the given value is not found 3 or more times in the dice roll", ->
    spark.isTriple(4).should.be.false
