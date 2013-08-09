dice_list = $('#dice-list')
gameboard = $('#gameboard')
showrules = $('#showrules')
cheatsheet = $('#cheatsheet')
leaderboard = $('#leaderboard')
leaderboard_list = leaderboard.find('ol')

$(document).ready ->
  init = ->
    showrules.on 'click',->
      cheatsheet.toggleClass('hidden')

    cheatsheet.on 'click',->
      $(this).toggleClass('hidden')

    gameboard.on 'click', '.roller, .roll', ->
      if spark.diceleft is 0
        spark.diceleft = 6
      spark.rollEm(spark.diceleft)

    gameboard.on 'click', '.bank', ->
      spark.bankIt(spark.table)

    dice_list.on 'click', 'li', ->
      el = $(this)
      value = el.attr('data-value')
      triple = "triple" +value
      unless el.hasClass('keeper')
        spark.playerMove.isYahtzee(el)
        spark.playerMove.isTriplePoints(el, value, triple)
        spark.playerMove.isSinglePoints(el, value, triple)
      spark.playerMove.isHotDice()

    fetchLeaders = ->
      leaderboard_list.empty()
      $.getJSON '/highscores', (data)->
        _.each data, (data)->
          score = spark.formatScore(data.score)
          leaderboard_list.append("<li>#{data.name} - #{score}</li>")

    leaderboard.on 'click', '#close', ->
      leaderboard.toggleClass('hidden')

    leaderboard.on 'click', '#submit', (e)->
      e.preventDefault()
      name = leaderboard.find("form input[type='text']").val()
      score = leaderboard.find('.highscore #winningscore').attr('data-value')
      $.ajax
        type: 'POST'
        contentType: 'application/json'
        dataType: 'json'
        url: '/highscores'
        data: JSON.stringify {name: name, score: score}
        success: ->
          leaderboard.find('form')[0].reset()
          leaderboard.find('form').hide()
          leaderboard.find('.message').hide()
          leaderboard.find('.highscore').hide()
          fetchLeaders()








  init()
