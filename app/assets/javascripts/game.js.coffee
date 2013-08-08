dice_list = $('#dice-list')
gameboard = $('#gameboard')

$(document).ready ->
  init = ->
    spark.setPlayer(spark.currentplayer)

    gameboard.on 'click', '.roller, .roll', ->
      if spark.diceleft is 0
        spark.diceleft = 6
      spark.rollEm(spark.diceleft)

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
            spark.diceleft -= 3
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
            spark.diceleft -= 1
            if el.hasClass('scorable')
              if n is '1'
                spark.tableIt(100)
              else
                spark.tableIt(50)
              el.addClass('keeper')
      if spark.diceleft is 0
        alert "Hot Dice! You can roll em all again."
  init()
