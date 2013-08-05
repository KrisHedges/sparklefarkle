//= require game

describe 'spark.rollDice', ->
  it 'Should return an array of numbers the length of the number of dice being
  rolled defaulting to 6 if unspecified', ->
    expect(spark.rollDice()).to.be.an.instanceof(Array)
    spark.rollDice().should.have.length(6)
    spark.rollDice(5).should.have.length(5)
    spark.rollDice(2).should.have.length(2)

  it 'Should only contain whole numbers that are between 1 and 6.', ->
    roll = spark.rollDice()
    evaluate = (n)->
      if n >= 1 and n <=6
        true
      else
        throw new Error(n + ' is not >=1 or <=6')

    evaluate n for n in roll
