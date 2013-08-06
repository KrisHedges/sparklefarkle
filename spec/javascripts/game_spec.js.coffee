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
  it "Should return true if the given value is found 3 or more times in the dice roll", ->
    dice = [1,2,2,2,4,5]
    spark.isTriple(2, dice).should.be.true

  it "Should return false if the given value is not found 3 or more times in the dice roll", ->
    dice = [1,2,3,2,4,5]
    spark.isTriple(4, dice).should.be.false


describe 'spark.isFarked', ->
  it "Should return true if there are no scorable dice in the dice roll.", ->
    dice = [2,4,3,6,2,3]
    spark.isFarked(dice).should.be.true

  it "Should return false if there is at least one scorable die in the dice roll.", ->
    dice = [2,4,3,6,2,1]
    spark.isFarked(dice).should.be.false

  it "Should return false if there is at least one scorable triple in the dice roll.", ->
    dice = [2,4,2,6,2,3]
    spark.isFarked(dice).should.be.false
