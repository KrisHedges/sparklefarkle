class Highscore < ActiveRecord::Base
  attr_accessible :name, :score
end
