dice_list = $('#dice-list')
gameboard = $('#gameboard')
leaderboard = $('#leaderboard')
leaderboard_list = leaderboard.find('ol')

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

    fetchLeaders = ->
      leaderboard_list.empty()

      $.getJSON '/highscores', (data)->
        _.each data, (data)->
          leaderboard_list.append("<li>#{data.name} - #{data.score}</li>")
    fetchLeaders()
    leaderboard.on 'click', '.close', ->
      leaderboard.toggleClass('hidden')

    leaderboard.on 'click', 'button', (e)->
      e.preventDefault()
      name = leaderboard.find("form input[type='text']").val()
      score = leaderboard.find('.highscore span').attr('data-value')
      $.ajax
        type: 'POST'
        contentType: 'application/json'
        dataType: 'json'
        url: '/highscores'
        data: JSON.stringify {name: name, score: score}
        success: ->
          leaderboard.find('form')[0].reset()
          leaderboard.find('form').hide()
          fetchLeaders()








  init()
