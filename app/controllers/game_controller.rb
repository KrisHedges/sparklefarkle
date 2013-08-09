class GameController < ApplicationController
  before_filter :load_highscores
  def index
  end
end
