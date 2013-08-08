class HighscoresController < ApplicationController
  respond_to :json

  def index
    @highscores = Highscore.find(:all, :order =>'score DESC', :limit => '50')
    respond_with(@highscores) do |format|
      format.json { render :json => @highscores }
    end
  end

  def create
    @highscore = Highscore.new(params[:highscore])
    if @highscore.save
      @highscores = Highscore.order('created_at')
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
