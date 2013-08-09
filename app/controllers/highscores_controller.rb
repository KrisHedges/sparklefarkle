class HighscoresController < ApplicationController
  respond_to :json

  def index
    load_highscores
    respond_with(@highscores) do |format|
      format.json { render :json => @highscores }
    end
  end

  def create
    @highscore = Highscore.new(params[:highscore])
    if @highscore.save
      load_highscores
      respond_with(@highscores) do |format|
        format.json { render :json => @highscores }
      end
    else
      @errors = @highscore.errors.full_messages
      respond_with(@errors) do |format|
        format.json { render :json => @errors }
      end
    end
  end

end
