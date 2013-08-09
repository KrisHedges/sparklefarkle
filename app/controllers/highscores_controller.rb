class HighscoresController < ApplicationController
  respond_to :json

  def index
    load_highscores
    respond_with(@highscores)
  end

  def create
    @highscore = Highscore.create(params[:highscore])
    respond_with(@highscore)
  end

end
