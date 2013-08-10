# SparkleFarkle

SparkleFarkle is a web-based 2 player (in-person) farkle game created using Ruby on Rails and a fairly hefty dose of javascript. You can see a demo of the app running at:

   http://sparklefarkle.herokuapp.com

## Getting Started

1. At the command prompt, you'll first need clone this repository.

   ```
   git clone git://github.com/InkSpeck/sparklefarkle.git
   ```
   
2. Change directory to the new <tt>sparklefarkle/</tt> directory and install all of the gems you'll need to run it:

   ```
   cd sparklefarkle
   bundle install
   ```

3. Create the database for the leaderboard.

   ```
   bundle exec rake db:migrate
   ```

4. Now you should be able to start up the server with:

   ```
   rails s
   ```

5. Go to http://localhost:3000/ and you should see the game running in your browser.

6. Have fun playing sparklefarkle with a friend!

## Testing SparkleFarkle

The app includes some javascript tests for the many of the core parts of the game.
They were created using mocha & chai through the konacha gem and are located in the <tt>spec/</tt> directory.

1. To run the tests, at the command prompt:

   ```
   bundle exec rake konacha:serve
   ```

2. Then in your browser go to http://localhost:3500 and you should see the test output.



