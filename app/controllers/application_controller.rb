class ApplicationController < ActionController::Base
  protect_from_forgery

  private
    def load_highscores
      @highscores = Highscore.find(:all, :order =>'score DESC', :limit => '50')

    end
end
